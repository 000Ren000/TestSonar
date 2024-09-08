﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ЗаявкаНаКомандировку") Тогда
		Документы.ЗаявкаНаКомандировку.ЗаполнитьПоОснованию(ЭтотОбъект, ДанныеЗаполнения);
	КонецЕсли;
	
	ЗаполнениеОбъектовПоСтатистике.ЗаполнитьРеквизитыОбъекта(ЭтотОбъект, ДанныеЗаполнения);
	
	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	ПараметрыВыбораСтатейИАналитик = Документы.Бронирование.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ВзаиморасчетыСервер.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения);
	
	БронированиеЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
	ВзаиморасчетыСервер.ПриКопировании(ЭтотОбъект);
	
	БронированиеЛокализация.ПриКопировании(ЭтотОбъект, ОбъектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.БронированиеЧерезАгента Тогда
		НепроверяемыеРеквизиты.Добавить("Агент");
		НепроверяемыеРеквизиты.Добавить("КонтрагентАгент");
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.БронированиеЧерезПодотчетноеЛицо Тогда
		НепроверяемыеРеквизиты.Добавить("ПодотчетноеЛицо");
		НепроверяемыеРеквизиты.Добавить("ПодразделениеПодотчетногоЛица");
	КонецЕсли;
	
	Если ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.БронированиеЧерезАгента
		И ХозяйственнаяОперация <> Перечисления.ХозяйственныеОперации.БронированиеУПоставщика Тогда
		НепроверяемыеРеквизиты.Добавить("Договор");
	КонецЕсли;
	
	Если ТипБронирования = Перечисления.ТипыБронирования.Бронирование Тогда
		НепроверяемыеРеквизиты.Добавить("Перевозчик");
		НепроверяемыеРеквизиты.Добавить("КонтрагентПеревозчик");
	КонецЕсли;
	
	МассивРеквизитовРучнойПроверки = Новый Массив;
	МассивРеквизитовРучнойПроверки.Добавить("Операции.Сумма");
	МассивРеквизитовРучнойПроверки.Добавить("Операции.Дата");
	МассивРеквизитовРучнойПроверки.Добавить("Операции.СтатьяРасходов");
	МассивРеквизитовРучнойПроверки.Добавить("Операции.АналитикаРасходов");
	МассивРеквизитовРучнойПроверки.Добавить("Операции.АналитикаАктивовПассивов");
	МассивРеквизитовРучнойПроверки.Добавить("Операции.СтавкаНДС");
	
	Для каждого Реквизит Из МассивРеквизитовРучнойПроверки Цикл
		НепроверяемыеРеквизиты.Добавить(Реквизит);
	КонецЦикла;
	
	КлючДанных = ОбщегоНазначенияУТ.КлючДанныхДляСообщенияПользователю(ЭтотОбъект);
	ТабличнаяЧасть = Метаданные().ТабличныеЧасти.Найти("Операции");
	Реквизит = ТабличнаяЧасть.Реквизиты.Найти("СтатьяРасходов");
	
	Для каждого СтрокаТЧ Из Операции Цикл
		Если СтрокаТЧ.ТипОперации = Перечисления.ТипыОперацийСБилетами.Возврат
			И СтрокаТЧ.СуммаШтрафа <> 0 И Не ЗначениеЗаполнено(СтрокаТЧ["СтатьяРасходов"]) Тогда
		
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Операции", СтрокаТЧ.НомерСтроки, "СтатьяРасходов");
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(НСтр("ru = 'Не заполнено поле ""%1"" в строке %2 списка ""%3""'"),
					Реквизит.Синоним, СтрокаТЧ.НомерСтроки, ТабличнаяЧасть.Синоним),
				КлючДанных,
				Поле,
				"Объект",
				Отказ);
		КонецЕсли;
	КонецЦикла;
	
	Реквизиты = Новый Структура("Операции", "СтатьяРасходов,АналитикаРасходов");
	ПланыВидовХарактеристик.СтатьиРасходов.ПроверитьЗаполнениеАналитик(ЭтотОбъект, Реквизиты, НепроверяемыеРеквизиты, Отказ);
	
	ПроверитьДатыПоездки(Отказ);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
	БронированиеЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	СуммаКВыдачеНакопительная = 0;
	СуммаДокументаНакопительная = 0;
	СуммаНДСНакопительная = 0;
	СуммаНеОблагаемаяНДСНакопительная = 0;
	ТекущийИтог = 0;
	Для каждого СтрокаТЧ Из Операции Цикл
		Если СтрокаТЧ.ТипОперации = Перечисления.ТипыОперацийСБилетами.Покупка
			Или СтрокаТЧ.ТипОперации = Перечисления.ТипыОперацийСБилетами.Доплата Тогда
			СуммаОперации = СтрокаТЧ.Сумма;
			СуммаНДСОперации = СтрокаТЧ.СуммаНДС;
			СуммаНеОблагаемаяНДСОперации = СтрокаТЧ.СуммаНеОблагаемаяНДС;
			СуммаШтрафа = 0;
			ТекущийИтог = ТекущийИтог + СтрокаТЧ.Сумма;
			СтрокаТЧ.СуммаИтог = ТекущийИтог;
		ИначеЕсли СтрокаТЧ.ТипОперации = Перечисления.ТипыОперацийСБилетами.Возврат Тогда
			СуммаОперации = -СтрокаТЧ.Сумма;
			СуммаНДСОперации = -СтрокаТЧ.СуммаНДС;
			СуммаНеОблагаемаяНДСОперации = -СтрокаТЧ.СуммаНеОблагаемаяНДС;
			СуммаШтрафа = СтрокаТЧ.СуммаШтрафа;
		КонецЕсли;
		СуммаКВыдачеНакопительная = СуммаКВыдачеНакопительная + СуммаОперации;
		СуммаДокументаНакопительная = СуммаДокументаНакопительная + СуммаОперации + СуммаШтрафа;
		СуммаНДСНакопительная = СуммаНДСНакопительная + СуммаНДСОперации;
		СуммаНеОблагаемаяНДСНакопительная = СуммаНеОблагаемаяНДСНакопительная + СуммаНеОблагаемаяНДСОперации;
	КонецЦикла;
	СуммаКВыдаче = СуммаКВыдачеНакопительная;
	СуммаДокумента = СуммаДокументаНакопительная;
	СуммаНДС = СуммаНДСНакопительная;
	СуммаНеОблагаемаяНДС = СуммаНеОблагаемаяНДСНакопительная;
	
	СтрокаТЧ = Операции.Найти(Перечисления.ТипыОперацийСБилетами.Покупка);
	Если СтрокаТЧ <> Неопределено Тогда
		СтавкаНДС = СтрокаТЧ.СтавкаНДС;
	КонецЕсли;
	
	ОперацияПокупки = Операции.Найти(Перечисления.ТипыОперацийСБилетами.Покупка, "ТипОперации");
	Если ОперацияПокупки <> Неопределено Тогда
		ОперацияПокупки.Дата = Дата;
	КонецЕсли;
	
	Состояние = НСтр("ru='Куплен'");
	Если Операции.Найти(Перечисления.ТипыОперацийСБилетами.Доплата, "ТипОперации") <> Неопределено Тогда
		Состояние = НСтр("ru='С доплатой'");
	КонецЕсли;
	Если Операции.Найти(Перечисления.ТипыОперацийСБилетами.Возврат, "ТипОперации") <> Неопределено И СуммаКВыдаче <= 0 Тогда
		Состояние = НСтр("ru='Возвращен'");
	КонецЕсли;
	
	Если РежимЗаписи <> РежимЗаписиДокумента.Запись Тогда
		ПроверитьЗапретИзмененияДанных(Отказ);
	КонецЕсли;
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "Операции");
	
	Для каждого СтрокаТЧ Из Операции Цикл
		Если СтрокаТЧ.СуммаШтрафа <> 0 Тогда
			СтрокаТЧ.ИдентификаторСтрокиШтрафа = Строка(Новый УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыВыбораСтатейИАналитик = Документы.Бронирование.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ВзаиморасчетыСервер.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи);
	
	ПараметрыРегистрации = Документы.Бронирование.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПередЗаписью(ПараметрыРегистрации, РежимЗаписи, ПометкаУдаления, Проведен);
	
	БронированиеЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
	ДополнительныеСвойства.Вставить("АвансовыйОтчет", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "АвансовыйОтчет"));
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПараметрыРегистрации = Документы.Бронирование.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриПроведении(ПараметрыРегистрации);
	
	БронированиеЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПараметрыРегистрации = Документы.Бронирование.ПараметрыРегистрацииСчетовФактурПолученных(ЭтотОбъект);
	УчетНДСУП.АктуализироватьСчетаФактурыПолученныеПриУдаленииПроведения(ПараметрыРегистрации);
	
	БронированиеЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	Если ЗначениеЗаполнено(АвансовыйОтчет)
		И Не ДополнительныеСвойства.Свойство("НеОбновлятьАвансовыйОтчет") Тогда
		
		ТаблицыДляДвижений = ПроведениеДокументов.ДанныеДокументаДляПроведения(АвансовыйОтчет, "РеестрДокументов");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанные(ТаблицыДляДвижений, АвансовыйОтчет, Неопределено, Отказ);
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("АвансовыйОтчет")
		И Не ДополнительныеСвойства.Свойство("НеОбновлятьАвансовыйОтчет")
		И ЗначениеЗаполнено(ДополнительныеСвойства.АвансовыйОтчет)
		И ДополнительныеСвойства.АвансовыйОтчет <> АвансовыйОтчет Тогда
		
		ТаблицыДляДвижений = ПроведениеДокументов.ДанныеДокументаДляПроведения(
			ДополнительныеСвойства.АвансовыйОтчет, "РеестрДокументов");
		РегистрыСведений.РеестрДокументов.ЗаписатьДанные(
			ТаблицыДляДвижений,
			ДополнительныеСвойства.АвансовыйОтчет,
			Неопределено,
			Отказ);
	КонецЕсли;
	
	БронированиеЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	БронированиеЛокализация.ПередУдалением(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)
	
	Ответственный = Пользователи.ТекущийПользователь();
	Валюта = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыСПоставщиками") Тогда
		Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
			ДанныеЗаполнения.Вставить("ХозяйственнаяОперация",
				Перечисления.ХозяйственныеОперации.БронированиеЧерезПодотчетноеЛицо);
		Иначе
			ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.БронированиеЧерезПодотчетноеЛицо;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьЗапретИзмененияДанных(Отказ)
	
	ДанныеДляПроверки = ДатыЗапретаИзменения.ШаблонДанныхДляПроверки();
	
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("Дата");
	ПроверяемыеРеквизиты.Добавить("ДатаПрибытия");
	
	НепроверяемыеРеквизиты = Новый Структура;
	Для каждого Реквизит Из Метаданные().Реквизиты Цикл
		Если ПроверяемыеРеквизиты.Найти(Реквизит.Имя) = Неопределено Тогда
			НепроверяемыеРеквизиты.Вставить(Реквизит.Имя);
		КонецЕсли;
	КонецЦикла;
	
	НепроверяемыеТабличныеЧасти = Новый Структура;
	НепроверяемыеТабличныеЧасти.Вставить("ДополнительныеРеквизиты");
	НепроверяемыеТабличныеЧасти.Вставить("Сборы");
	
	ИзмененияДокумента = ОбщегоНазначенияУТ.ИзмененияДокумента(ЭтотОбъект, НепроверяемыеРеквизиты, НепроверяемыеТабличныеЧасти);
	
	Если ИзмененияДокумента.Свойство("Реквизиты") Тогда
		Для каждого ИзменениеРеквизита Из ИзмененияДокумента.Реквизиты Цикл
			
			Если ЗначениеЗаполнено(ИзменениеРеквизита.СтароеЗначение) Тогда
				НоваяСтрока = ДанныеДляПроверки.Добавить();
				НоваяСтрока.Дата   = ИзменениеРеквизита.СтароеЗначение;
				НоваяСтрока.Раздел = "АвансовыеОтчеты";
				НоваяСтрока.Объект = Организация;
				
				НоваяСтрока = ДанныеДляПроверки.Добавить();
				НоваяСтрока.Дата   = ИзменениеРеквизита.СтароеЗначение;
				НоваяСтрока.Раздел = "ФинансовыйКонтур";
				НоваяСтрока.Объект = Организация;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ИзменениеРеквизита.НовоеЗначение) Тогда
				НоваяСтрока = ДанныеДляПроверки.Добавить();
				НоваяСтрока.Дата   = ИзменениеРеквизита.НовоеЗначение;
				НоваяСтрока.Раздел = "АвансовыеОтчеты";
				НоваяСтрока.Объект = Организация;
				
				НоваяСтрока = ДанныеДляПроверки.Добавить();
				НоваяСтрока.Дата   = ИзменениеРеквизита.НовоеЗначение;
				НоваяСтрока.Раздел = "ФинансовыйКонтур";
				НоваяСтрока.Объект = Организация;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ИзмененияДокумента.Свойство("ТабличныеЧасти") И ИзмененияДокумента.ТабличныеЧасти.Свойство("Операции") Тогда
		Для каждого ИзменениеОперации Из ИзмененияДокумента.ТабличныеЧасти.Операции Цикл
			Если ЗначениеЗаполнено(ИзменениеОперации.Дата) Тогда
				НоваяСтрока = ДанныеДляПроверки.Добавить();
				НоваяСтрока.Дата   = ИзменениеОперации.Дата;
				НоваяСтрока.Раздел = "АвансовыеОтчеты";
				НоваяСтрока.Объект = Организация;
				
				НоваяСтрока = ДанныеДляПроверки.Добавить();
				НоваяСтрока.Дата   = ИзменениеОперации.Дата;
				НоваяСтрока.Раздел = "ФинансовыйКонтур";
				НоваяСтрока.Объект = Организация;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ОписаниеДанных = Новый Структура;
	ОписаниеДанных.Вставить("НоваяВерсия", Истина);
	ОписаниеДанных.Вставить("Данные",      ЭтотОбъект);
	
	ОписаниеОшибки = "";
	Если ДатыЗапретаИзменения.НайденЗапретИзмененияДанных(ДанныеДляПроверки, ОписаниеДанных, ОписаниеОшибки) Тогда
		ВызватьИсключение ОписаниеОшибки;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьДатыПоездки(Отказ)

	Если ДатаПрибытия < ДатаОтправления
		И ДатаОтправления - ДатаПрибытия >= 90000 Тогда
		
		ЗаголовокДатаОтправления = ?(ТипБронирования = Перечисления.ТипыБронирования.ЭлектронныйБилет,
									НСтр("ru = 'Дата отправления'"),
									НСтр("ru = 'Дата начала'"));
		ЗаголовокДатаПрибытия = ?(ТипБронирования = Перечисления.ТипыБронирования.ЭлектронныйБилет,
								НСтр("ru = 'Дата прибытия'"),
								НСтр("ru = 'Дата окончания'"));
		
		ТекстСообщения = СтрШаблон(Нстр("ru = 'Значение в поле ""%1"" не может быть меньше значения ""%2"" более, чем на 25 часов'"),
							ЗаголовокДатаПрибытия,
							ЗаголовокДатаОтправления);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Ссылка, "ДатаПрибытия", "Объект", Отказ);
	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли