﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ОбновитьИнтерфейс;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РедактированиеСверткаРегистраСоответствиеНоменклатуры = ПравоДоступа(
		"Редактирование", Метаданные.Константы.ИспользоватьСверткуРегистраСоответствиеНоменклатурыСАТУРН);
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	ОбновитьИнтерфейсПрограммы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРНПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимРаботыСТестовымКонтуромСАТУРНПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияКилограммИСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияЛитрИСПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСверткуРегистраСоответствиеНоменклатурыПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиПодключенияСАТУРН(Команда)
	
	ОткрытьФорму("РегистрСведений.НастройкиПодключенияСАТУРН.ФормаСписка", , ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыОптимизации(Команда)
	
	ОткрытьФорму("Обработка.ПанельАдминистрированияСАТУРН.Форма.ПараметрыОптимизации");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиРегламентныхЗаданийДляОбмена(Команда)
	
	ОткрытьФорму("Справочник.НастройкиРегламентныхЗаданийСАТУРН.Форма.ФормаНастроек");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиСверткиРегистраСоответствиеНоменклатуры(Команда)
	
	Если Не РедактированиеСверткаРегистраСоответствиеНоменклатуры Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеСверткиРегистраСоответствиеНоменклатуры", ЭтотОбъект);
	
	ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеСверткиРегистраСоответствиеНоменклатуры);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
		ОбновитьИнтерфейс = Истина;
	КонецЕсли;
	
	Если Результат <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	СохранитьЗначениеКонстанты(КонстантаИмя);
	
	Если КонстантаИмя = Элементы.ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН.Имя Тогда
		Если Не НаборКонстант.ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН Тогда
			ИзменитьИспользованиеЗадания("СверткаРегистраСоответствиеНоменклатурыСАТУРН", Ложь);
			СохранитьЗначениеКонстанты("ИспользоватьСверткуРегистраСоответствиеНоменклатурыСАТУРН", Ложь);
		КонецЕсли;
	КонецЕсли;
	
	Если КонстантаИмя = "ИспользоватьСверткуРегистраСоответствиеНоменклатурыСАТУРН" Тогда
		ИзменитьИспользованиеЗадания("СверткаРегистраСоответствиеНоменклатурыСАТУРН", НаборКонстант.ИспользоватьСверткуРегистраСоответствиеНоменклатурыСАТУРН);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьЗначениеКонстанты(КонстантаИмя, Знач КонстантаЗначение = Неопределено)
	
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		Если КонстантаЗначение = Неопределено Тогда
			КонстантаЗначение = НаборКонстант[КонстантаИмя];
		КонецЕсли;
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
			Если КонстантаЗначение <> Неопределено Тогда
				НаборКонстант[КонстантаИмя] = КонстантаЗначение;
			КонецЕсли;
		КонецЕсли;
		
		СобытияФормИСПереопределяемый.ОбновитьФормуНастройкиПриЗаписиПодчиненныхКонстант(ЭтотОбъект, КонстантаИмя, КонстантаЗначение);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН;
		
		ИнтеграцияИСКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН, ЗначениеКонстанты);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.РежимРаботыСТестовымКонтуромСАТУРН" 
		ИЛИ РеквизитПутьКДанным = "" Тогда
		ЗначениеКонстанты = НаборКонстант.РежимРаботыСТестовымКонтуромСАТУРН;
		
		ИнтеграцияИСКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.РежимРаботыСТестовымКонтуромСАТУРН, ЗначениеКонстанты);
		
	КонецЕсли;
	
	ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН = ПолучитьФункциональнуюОпцию("ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН");
	
	Элементы.РежимРаботыСТестовымКонтуромСАТУРН.Доступность    = ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН;
	Элементы.ЕдиницаИзмеренияКилограммИС.Доступность           = ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН;
	Элементы.ЕдиницаИзмеренияЛитрИС.Доступность                = ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН;
	Элементы.НастройкиРегламентныхЗаданийДляОбмена.Доступность = ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН;
	Элементы.ГруппаСверткаРегистраСоответствиеНоменклатуры.Доступность =
		ВестиУчетПестицидовАгрохимикатовТукосмесейСАТУРН;
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Элементы.ГруппаСверткаРегистраСоответствиеНоменклатуры.Видимость = Ложь;
	Иначе
		
		Элементы.ГруппаСверткаРегистраСоответствиеНоменклатуры.ТолькоПросмотр =
			Не РедактированиеСверткаРегистраСоответствиеНоменклатуры;
		
		УстановитьНастройкиЗаданий();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьИспользованиеЗадания(ИмяЗадания, Использование)
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Использование", Истина И Использование);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьРасписаниеЗадания(ИмяЗадания, РасписаниеРегламентногоЗадания)
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];

	ПараметрыЗадания = Новый Структура;
	ПараметрыЗадания.Вставить("Расписание", РасписаниеРегламентногоЗадания);
	РегламентныеЗаданияСервер.ИзменитьЗадание(РегЗадание.УникальныйИдентификатор, ПараметрыЗадания);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", ИмяЗадания);
	РегЗадание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	Элемент = Элементы[ИмяЗадания];
	УстановитьТекстНадписиРегламентнойНастройки(РегЗадание, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуРасписанияОбмена(ОписаниеОповещения, РасписаниеРегламентногоЗадания)
	
	Если РасписаниеРегламентногоЗадания = Неопределено Тогда
		РасписаниеРегламентногоЗадания = Новый РасписаниеРегламентногоЗадания;
	КонецЕсли;
	
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(РасписаниеРегламентногоЗадания);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЗаданий()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Метаданные", "СверткаРегистраСоответствиеНоменклатурыСАТУРН");
	Задание = РегламентныеЗаданияСервер.НайтиЗадания(ПараметрыОтбора)[0];
	
	РасписаниеСверткиРегистраСоответствиеНоменклатуры = Задание.Расписание;
	
	Элементы.СверткаРегистраСоответствиеНоменклатурыСАТУРН.Доступность = Задание.Использование;
	УстановитьТекстНадписиРегламентнойНастройки(Задание, Элементы.СверткаРегистраСоответствиеНоменклатурыСАТУРН);
	
	УстановитьПривилегированныйРежим(Ложь);

КонецПроцедуры

&НаСервере
Процедура УстановитьТекстНадписиРегламентнойНастройки(Задание, Элемент)
	
	Перем ТекстРасписания, РасписаниеАктивно;
	
	ОбщегоНазначенияИС.ПолучитьТекстЗаголовкаИРасписанияРегламентнойНастройки(Задание, ТекстРасписания, РасписаниеАктивно);
	Элемент.Заголовок = ТекстРасписания;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеСверткиРегистраСоответствиеНоменклатуры(РасписаниеЗадания, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеЗадания = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РасписаниеСверткиРегистраСоответствиеНоменклатуры = РасписаниеЗадания;
	
	ИзменитьРасписаниеЗадания("СверткаРегистраСоответствиеНоменклатурыСАТУРН",
		РасписаниеСверткиРегистраСоответствиеНоменклатуры);
	
КонецПроцедуры

#КонецОбласти
