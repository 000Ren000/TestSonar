﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ТекСтрокаДопДанные; // Текущая строка табличной части ДополнительныеДанные.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Поля = ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Поля;
	
	Для Каждого ТекПоле Из Поля Цикл
		
		НовоеПоле = ДополнительныеДанные.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеПоле, ТекПоле);
		НовоеПоле.Представление = НовоеПоле.Значение;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
    Если Параметры.Свойство("АвтоТест") Тогда
        Возврат;
    КонецЕсли;
	
	Если Параметры.Свойство("АдресХранилищаСКД") Тогда
		АдресХранилищаСКД = Параметры.АдресХранилищаСКД;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДополнительныеДанные

&НаКлиенте
Процедура ДополнительныеДанныеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТД = Элементы.ДополнительныеДанные.ТекущиеДанные;
	
	Если ТД<>Неопределено Тогда
		НачатьРедактированиеПоля(ТД);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеДанныеПриАктивизацииСтроки(Элемент)

	Если ТекСтрокаДопДанные<>Элементы.ДополнительныеДанные.ТекущаяСтрока Тогда
		
		ТекСтрокаДопДанные = Элементы.ДополнительныеДанные.ТекущаяСтрока;
		ТД = Элементы.ДополнительныеДанные.ТекущиеДанные;
		
		Если ТД<>Неопределено Тогда
			
			Элементы.ДополнительныеДанныеИзменитьПоле.Доступность = Истина;
			Элементы.ДополнительныеДанныеУдалитьПоле.Доступность = Истина;
			
		Иначе
			Элементы.ДополнительныеДанныеИзменитьПоле.Доступность = Ложь;
			Элементы.ДополнительныеДанныеУдалитьПоле.Доступность = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Поля.Очистить();
	
	Для Каждого ТекПоле Из ДополнительныеДанные Цикл
		
		ОписаниеПоляДопДанных = Новый Структура;
		ОписаниеПоляДопДанных.Вставить("Наименование",			ТекПоле.Наименование);
		ОписаниеПоляДопДанных.Вставить("Тип",					ТекПоле.Тип);
		ОписаниеПоляДопДанных.Вставить("ТипЗаполнения",			ТекПоле.ТипЗаполнения);
		ОписаниеПоляДопДанных.Вставить("ЗначениеПоУмолчанию",	ТекПоле.ЗначениеПоУмолчанию);
		ОписаниеПоляДопДанных.Вставить("Значение",				ТекПоле.Значение);
		ОписаниеПоляДопДанных.Вставить("Верх",					Неопределено);
		ОписаниеПоляДопДанных.Вставить("Лево",					Неопределено);
		ОписаниеПоляДопДанных.Вставить("Низ",					Неопределено);
		ОписаниеПоляДопДанных.Вставить("Право",					Неопределено);
		ОписаниеПоляДопДанных.Вставить("Ориентация",			Неопределено);
		ОписаниеПоляДопДанных.Вставить("Шрифт",					Неопределено);
		ОписаниеПоляДопДанных.Вставить("РамкаСлева",			Неопределено);
		ОписаниеПоляДопДанных.Вставить("РамкаСверху",			Неопределено);
		ОписаниеПоляДопДанных.Вставить("РамкаСправа",			Неопределено);
		ОписаниеПоляДопДанных.Вставить("РамкаСнизу",			Неопределено);
		ОписаниеПоляДопДанных.Вставить("ТипРамки",				Неопределено);
		ОписаниеПоляДопДанных.Вставить("ТолщинаРамки",			Неопределено);
		ОписаниеПоляДопДанных.Вставить("ТипШтрихкода",			Неопределено);
		ОписаниеПоляДопДанных.Вставить("РазмерШрифтаПодписи",	Неопределено);
		ОписаниеПоляДопДанных.Вставить("ПодписьШтрихкода",		Неопределено);
		ОписаниеПоляДопДанных.Вставить("КонтрольныйСимвол",		Неопределено);
		ОписаниеПоляДопДанных.Вставить("ПоложениеПоГоризонтали",Неопределено);
		ОписаниеПоляДопДанных.Вставить("ПоложениеПоВертикали",	Неопределено);
		ОписаниеПоляДопДанных.Вставить("Многострочность",		Неопределено);
		ОписаниеПоляДопДанных.Вставить("Формат",				ТекПоле.Формат);
			
		ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Поля.Добавить(ОписаниеПоляДопДанных);
		
	КонецЦикла;
	
	Закрыть(КодВозвратаДиалога.ОК);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоле(Команда)
	
	НачатьДобавлениеПоля();
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПоле(Команда)
	
	ТД = Элементы.ДополнительныеДанные.ТекущиеДанные;
	
	Если ТД<>Неопределено Тогда
		НачатьРедактированиеПоля(ТД);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПоле(Команда)
	
	ТД = Элементы.ДополнительныеДанные.ТекущиеДанные;
	
	Если ТД<>Неопределено Тогда
		
		ДополнительныеДанные.Удалить(ТД);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьДобавлениеПоля()
	
	ОписаниеПоля = Новый Структура;
	ОписаниеПоля.Вставить("Наименование", Строка(Новый УникальныйИдентификатор));
	ОписаниеПоля.Вставить("Верх", 0);
	ОписаниеПоля.Вставить("Лево", 0);
	ОписаниеПоля.Вставить("Низ", 0);
	ОписаниеПоля.Вставить("Право", 0);
	
	ОписаниеПоля.Вставить("ТипЗаполнения", "Parameter");
	
	ПередаваемыеПараметры = Новый Структура;
	ПередаваемыеПараметры.Вставить("ОписаниеПоля", ОписаниеПоля);
	ПередаваемыеПараметры.Вставить("РедактированиеПоляДополнительно", Истина);
	ПередаваемыеПараметры.Вставить("ШагСетки", ШагСетки);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("НачатьДобавлениеРедактированиеПоляЗавершение", ЭтотОбъект, ПередаваемыеПараметры);
	ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенниковБПО.Форма.РедакторЭтикетокФормаРедактированияПоляМакета", Новый Структура("АдресХранилищаСКД", АдресХранилищаСКД),,,,, ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьРедактированиеПоля(Поле)
	
	ОписаниеПоля = Новый Структура;
	ОписаниеПоля.Вставить("Наименование",			Поле.Наименование);
	ОписаниеПоля.Вставить("Тип",					Поле.Тип);
	ОписаниеПоля.Вставить("ТипЗаполнения",			Поле.ТипЗаполнения);
	ОписаниеПоля.Вставить("ЗначениеПоУмолчанию",	Поле.ЗначениеПоУмолчанию);
	ОписаниеПоля.Вставить("Значение",				Поле.Значение);
	ОписаниеПоля.Вставить("Верх",					?(ЗначениеЗаполнено(Поле.Верх), Поле.Верх, 1));
	ОписаниеПоля.Вставить("Лево",					?(ЗначениеЗаполнено(Поле.Лево), Поле.Лево, 1));
	ОписаниеПоля.Вставить("Низ",					?(ЗначениеЗаполнено(Поле.Низ), Поле.Низ, 1));
	ОписаниеПоля.Вставить("Право",					?(ЗначениеЗаполнено(Поле.Право), Поле.Право, 1));
	ОписаниеПоля.Вставить("Ориентация",				Поле.Ориентация);
	ОписаниеПоля.Вставить("Шрифт",					Новый Шрифт(Поле.ИмяШрифта, ?(ЗначениеЗаполнено(Поле.РазмерШрифта), Поле.РазмерШрифта, Неопределено), Поле.Жирный, Поле.Наклонный, Поле.Подчеркивание, Поле.Зачеркивание));
	ОписаниеПоля.Вставить("РамкаСлева",				Поле.РамкаСлева);
	ОписаниеПоля.Вставить("РамкаСверху",			Поле.РамкаСверху);
	ОписаниеПоля.Вставить("РамкаСправа",			Поле.РамкаСправа);
	ОписаниеПоля.Вставить("РамкаСнизу",				Поле.РамкаСнизу);
	ОписаниеПоля.Вставить("ТипРамки",				?(ЗначениеЗаполнено(Поле.ТипРамки), Поле.ТипРамки, "Solid"));
	ОписаниеПоля.Вставить("ТолщинаРамки",			?(ЗначениеЗаполнено(Поле.ТолщинаРамки), Поле.ТолщинаРамки, 1));
	ОписаниеПоля.Вставить("ТипШтрихкода",			?(ЗначениеЗаполнено(Поле.ТипШтрихкода), Поле.ТипШтрихкода, "EAN8"));
	ОписаниеПоля.Вставить("РазмерШрифтаПодписи",	?(ЗначениеЗаполнено(Поле.РазмерШрифтаПодписи), Поле.РазмерШрифтаПодписи, 3));
	ОписаниеПоля.Вставить("ПодписьШтрихкода",		Поле.ПодписьШтрихкода);
	ОписаниеПоля.Вставить("КонтрольныйСимвол",		Поле.КонтрольныйСимвол);
	ОписаниеПоля.Вставить("ПоложениеПоГоризонтали",	?(ЗначениеЗаполнено(Поле.ПоложениеПоГоризонтали), Поле.ПоложениеПоГоризонтали, "Left"));
	ОписаниеПоля.Вставить("ПоложениеПоВертикали",	?(ЗначениеЗаполнено(Поле.ПоложениеПоВертикали), Поле.ПоложениеПоВертикали, "Top"));
	ОписаниеПоля.Вставить("Многострочность",		Поле.Многострочность);
	ОписаниеПоля.Вставить("Формат",					Поле.Формат);
	
	РедактируемоеПоле = Новый Структура;
	РедактируемоеПоле.Вставить("Наименование",	Поле.Наименование);
	РедактируемоеПоле.Вставить("Тип",			Поле.Тип);
	РедактируемоеПоле.Вставить("Верх",			Поле.Верх);
	РедактируемоеПоле.Вставить("Лево",			Поле.Лево);
	РедактируемоеПоле.Вставить("Низ",			Поле.Низ);
	РедактируемоеПоле.Вставить("Право",			Поле.Право);
	
	ПередаваемыеПараметры = Новый Структура;
	ПередаваемыеПараметры.Вставить("ОписаниеПоля", ОписаниеПоля);
	ПередаваемыеПараметры.Вставить("РедактируемоеПоле", РедактируемоеПоле);
	ПередаваемыеПараметры.Вставить("РедактированиеПоляДополнительно", Истина);
	ПередаваемыеПараметры.Вставить("ШагСетки", ШагСетки);
	
	ОповещениеПриЗавершении = Новый ОписаниеОповещения("НачатьДобавлениеРедактированиеПоляЗавершение", ЭтотОбъект, ПередаваемыеПараметры);
	ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенниковБПО.Форма.РедакторЭтикетокФормаРедактированияПоляМакета", Новый Структура("АдресХранилищаСКД", АдресХранилищаСКД),,,,, ОповещениеПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьДобавлениеРедактированиеПоляЗавершение(Результат, ПередаваемыеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		
		Если ПередаваемыеПараметры.Свойство("РедактируемоеПоле") Тогда
			РедактируемоеПоле = ПередаваемыеПараметры.РедактируемоеПоле;
		Иначе
			РедактируемоеПоле = Неопределено;
		КонецЕсли;
		ОписаниеПоля = ПередаваемыеПараметры.ОписаниеПоля;
		
		СохранитьОписаниеПоля(ОписаниеПоля, РедактируемоеПоле);
		
	КонецЕсли;	
	
КонецПроцедуры

// Описание
// 
// Параметры:
// 	ОписаниеПоля - Структура - структура с полями:
// 	*Наименование - Строка - .
// 	РедактируемоеПоле - Структура - структура с полями:
// 	*Наименование - Строка - .
// 	*Тип - Строка - .
// 	*Верх - Строка - .
// 	*Лево - Строка - .
// 	*Низ - Строка - .
// 	*Право - Строка - .
&НаКлиенте
Процедура СохранитьОписаниеПоля(ОписаниеПоля, РедактируемоеПоле=Неопределено)
	
	Если РедактируемоеПоле<>Неопределено Тогда
		ПолеМакета = ДополнительныеДанные.НайтиСтроки(Новый Структура("Наименование", РедактируемоеПоле.Наименование))[0];
	Иначе
		ПолеМакета	= ДополнительныеДанные.Добавить();
	КонецЕсли;
	
	ПолеМакета.Тип	= ОписаниеПоля.Тип;
	ПолеМакета.Наименование	= ОписаниеПоля.Наименование;
	ПолеМакета.Значение = ОписаниеПоля.Значение;
	ПолеМакета.ТипЗаполнения = ОписаниеПоля.ТипЗаполнения;
	ПолеМакета.Значение = ОписаниеПоля.Значение;
	ПолеМакета.ЗначениеПоУмолчанию = ОписаниеПоля.ЗначениеПоУмолчанию;
	
	ПолеМакета.Представление				= ОписаниеПоля.Значение;
	ПолеМакета.Формат						= ОписаниеПоля.Формат;
	ПолеМакета.Верх							= Неопределено;
	ПолеМакета.Лево							= Неопределено;
	ПолеМакета.Низ							= Неопределено;
	ПолеМакета.Право						= Неопределено;
	ПолеМакета.Ориентация					= Неопределено;
	ПолеМакета.ИмяШрифта					= Неопределено;
	ПолеМакета.РазмерШрифта					= Неопределено;
	ПолеМакета.Жирный						= Неопределено;
	ПолеМакета.Наклонный					= Неопределено;
	ПолеМакета.Подчеркивание				= Неопределено;
	ПолеМакета.Зачеркивание					= Неопределено;
	ПолеМакета.РамкаСлева					= Неопределено;
	ПолеМакета.РамкаСверху					= Неопределено;
	ПолеМакета.РамкаСправа					= Неопределено;
	ПолеМакета.РамкаСнизу					= Неопределено;
	ПолеМакета.ТипРамки						= Неопределено;
	ПолеМакета.ТолщинаРамки					= Неопределено;
	ПолеМакета.ПоложениеПоГоризонтали		= Неопределено;
	ПолеМакета.ПоложениеПоВертикали			= Неопределено;
	ПолеМакета.Многострочность				= Неопределено;
	ПолеМакета.ТипШтрихкода					= Неопределено;
	ПолеМакета.КонтрольныйСимвол			= Неопределено;
	ПолеМакета.ПодписьШтрихкода				= Неопределено;
	ПолеМакета.РазмерШрифтаПодписи			= Неопределено;
	
КонецПроцедуры

#КонецОбласти