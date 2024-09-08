﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если Не ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПередачаПрочихРасходовМеждуФилиалами Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОрганизацияПолучатель");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПрочиеДоходыРасходы.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ПрочиеДоходыРасходыЛокализация.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)

	ИнициализироватьДокумент(ДанныеЗаполнения);
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПриобретениеТоваровУслуг") Тогда
		
		РеквизитыДляЗаполнения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения, "Организация");
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РеквизитыДляЗаполнения);
		
		ЗаполнитьНаправленияДеятельностиПоПоступлению(ДанныеЗаполнения); 
		
	
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПрочиеДоходыРасходы.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);

	ПрочиеДоходыРасходыЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихАктивовПассивов") Тогда
		
		Для Каждого ТекСтрока Из ПрочиеРасходы Цикл
			Если НЕ ЗначениеЗаполнено(ТекСтрока.СтатьяАктивовПассивов) Тогда
				ТекСтрока.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПрочиеПассивы;
			КонецЕсли;
		КонецЦикла;
		Для Каждого ТекСтрока Из ПрочиеДоходы Цикл
			Если НЕ ЗначениеЗаполнено(ТекСтрока.СтатьяАктивовПассивов) Тогда
				ТекСтрока.СтатьяАктивовПассивов = ПланыВидовХарактеристик.СтатьиАктивовПассивов.ПрочиеАктивы;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ПрочиеДоходы
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СторнированиеПрочихДоходов
		ИЛИ ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеклассификацияДоходов Тогда
		ПрочиеРасходы.Очистить();
	Иначе
		ПрочиеДоходы.Очистить();
	КонецЕсли;
	
	Для Каждого Строка Из ПрочиеРасходы Цикл
		Если НЕ ЗначениеЗаполнено(Строка.ДатаОтражения) Тогда
			Строка.ДатаОтражения = Дата;
		КонецЕсли;
	КонецЦикла;
	Для Каждого Строка Из ПрочиеДоходы Цикл
		Если НЕ ЗначениеЗаполнено(Строка.ДатаОтражения) Тогда
			Строка.ДатаОтражения = Дата;
		КонецЕсли;
	КонецЦикла;
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ПрочиеРасходы,ПрочиеДоходы");
	
	
	ПараметрыВыбораСтатейИАналитик = Документы.ПрочиеДоходыРасходы.ПараметрыВыбораСтатейИАналитик(ХозяйственнаяОперация);
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ПрочиеДоходыРасходыЛокализация.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
	ПрочиеДоходыРасходыЛокализация.ПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПрочиеДоходыРасходыЛокализация.ОбработкаПроведения(ЭтотОбъект, Отказ, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ПрочиеДоходыРасходыЛокализация.ОбработкаУдаленияПроведения(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ПрочиеРасходы,ПрочиеДоходы");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

Процедура ИнициализироватьДокумент(ДанныеЗаполнения = Неопределено)

	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Валюта = Константы.ВалютаУправленческогоУчета.Получить();
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ЗаполнитьНаправленияДеятельностиПоПоступлению(ДокументПоступления)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрочиеРасходы.Подразделение КАК КорПодразделение,
	|	ПрочиеРасходы.НаправлениеДеятельности КАК КорНаправлениеДеятельности,
	|	ПрочиеРасходы.СтатьяРасходов КАК КорСтатьяРасходов,
	|	ПрочиеРасходы.АналитикаРасходов КАК КорАналитикаРасходов,
	|	СУММА(ПрочиеРасходы.Сумма) КАК Сумма,
	|	СУММА(ПрочиеРасходы.СуммаБезНДС) КАК СуммаБезНДС,
	|	СУММА(ПрочиеРасходы.СуммаРегл) КАК СуммаРегл,
	|	СУММА(ПрочиеРасходы.ПостояннаяРазница) КАК ПостояннаяРазница,
	|	СУММА(ПрочиеРасходы.ВременнаяРазница) КАК ВременнаяРазница
	|ИЗ
	|	РегистрНакопления.ПрочиеРасходы КАК ПрочиеРасходы
	|ГДЕ
	|	ПрочиеРасходы.Регистратор = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ПрочиеРасходы.Подразделение,
	|	ПрочиеРасходы.НаправлениеДеятельности,
	|	ПрочиеРасходы.СтатьяРасходов,
	|	ПрочиеРасходы.АналитикаРасходов
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ПартииПрочихРасходов.Подразделение,
	|	ПартииПрочихРасходов.НаправлениеДеятельности,
	|	ПартииПрочихРасходов.СтатьяРасходов,
	|	ПартииПрочихРасходов.АналитикаРасходов,
	|	СУММА(ПартииПрочихРасходов.Стоимость),
	|	СУММА(ПартииПрочихРасходов.СтоимостьБезНДС),
	|	СУММА(ПартииПрочихРасходов.СтоимостьРегл),
	|	СУММА(ПартииПрочихРасходов.ПостояннаяРазница),
	|	СУММА(ПартииПрочихРасходов.ВременнаяРазница)
	|ИЗ
	|	РегистрНакопления.ПартииПрочихРасходов КАК ПартииПрочихРасходов
	|ГДЕ
	|	ПартииПрочихРасходов.Регистратор = &Ссылка
	|	И (ПартииПрочихРасходов.СтатьяРасходов.ВариантРаспределенияРасходовУпр = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров)
	|		ИЛИ ПартииПрочихРасходов.СтатьяРасходов.ВариантРаспределенияРасходовРегл = ЗНАЧЕНИЕ(Перечисление.ВариантыРаспределенияРасходов.НаСебестоимостьТоваров))
	|
	|СГРУППИРОВАТЬ ПО
	|	ПартииПрочихРасходов.Подразделение,
	|	ПартииПрочихРасходов.НаправлениеДеятельности,
	|	ПартииПрочихРасходов.СтатьяРасходов,
	|	ПартииПрочихРасходов.АналитикаРасходов";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументПоступления);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда
		ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.РеклассификацияРасходов;
		ПрочиеРасходы.Загрузить(РезультатЗапроса.Выгрузить());
	Иначе
		Текст = НСтр("ru = 'Нет данных для реклассификации расходов'");
		ВызватьИсключение Текст;
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

#КонецОбласти

#КонецЕсли
