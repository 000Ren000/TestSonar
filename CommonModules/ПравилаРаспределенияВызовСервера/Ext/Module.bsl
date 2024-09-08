﻿
#Область ПрограммныйИнтерфейс

// Дополнительные параметры открытия формы настройки отборов.
// Параметры:
//	Параметры - см. ПравилаРаспределенияКлиент.ПараметрыОткрытияФормыНастройкиОтбора
// Возвращаемое значение:
//	Структура - дополнительные параметры.
Функция ДополнительныеПараметрыНастройкиОтборов(Параметры) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("НеНастраиватьПараметры", Истина);
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Параметры.БазаРаспределения);
	ИмяСхемы = ИмяСхемыБазыРаспределения(Параметры.БазаРаспределения);
	Если ИмяСхемы = "МатериальныеЗатраты"
		Или ИмяСхемы = "МатериальныеИТрудозатраты" Тогда
		ДополнительныеПараметры.НеНастраиватьПараметры = Ложь;
	КонецЕсли;
	
	Схема = МенеджерОбъекта.ПолучитьМакет(ИмяСхемы);
	
	
	Для Каждого ИмяПоля Из Параметры.НедоступныеПоляОтбора Цикл
		
		НедоступноеПоле = Схема.НаборыДанных[0].Поля.Найти(ИмяПоля); // ПолеНабораДанныхСхемыКомпоновкиДанных
		Если Не НедоступноеПоле = Неопределено Тогда
			
			НедоступноеПоле.ОграничениеИспользования.Условие = Истина;
			НедоступноеПоле.ОграничениеИспользованияРеквизитов.Условие = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДополнительныеПараметры.Вставить("АдресСхемыКомпоновкиДанных",
		ПоместитьВоВременноеХранилище(Схема, Параметры.УникальныйИдентификатор));
	
	ДополнительныеПараметры.Вставить("АдресНастроекКомпоновкиДанных");
	Настройки = Параметры.КомпоновщикНастроек.ПолучитьНастройки();
	Если ЗначениеЗаполнено(Настройки) Тогда
		ДополнительныеПараметры.АдресНастроекКомпоновкиДанных = ПоместитьВоВременноеХранилище(Настройки,
			Параметры.УникальныйИдентификатор);
	КонецЕсли;
	
	Возврат ДополнительныеПараметры;
	
КонецФункции

// Вызывает функцию модуля менеджера базы распределения, которая возвращает имя схемы компоновки данных
// по переданной базе распределения.
// Параметры:
//	БазаРаспределения - ПеречислениеСсылка.ТипыБазыРаспределенияРасходов, 
//						ПеречислениеСсылка.НаправлениеРаспределенияПоПодразделениям - база распределения.
//	МенеджерОбъекта - ПеречислениеМенеджер, Неопределено - менеджер объекта базы распределения.
// Возвращаемое значение:
//	Строка - имя схемы базы распределения.
Функция ИмяСхемыБазыРаспределения(БазаРаспределения, МенеджерОбъекта = Неопределено) Экспорт
	
	Если МенеджерОбъекта = Неопределено Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(БазаРаспределения);
	КонецЕсли;
	
	Возврат МенеджерОбъекта.ИмяСхемыБазыРаспределения(БазаРаспределения);
	
КонецФункции

// Возвращает схему компоновки базы распределения.
// Параметры:
//	БазаРаспределения - ПеречислениеСсылка.ТипыБазыРаспределенияРасходов, 
//						ПеречислениеСсылка.НаправлениеРаспределенияПоПодразделениям - база распределения.
//	МенеджерОбъекта - ПеречислениеМенеджер, Неопределено - менеджер объекта базы распределения.
// Возвращаемое значение:
//	СхемаКомпоновкиДанных - схема компоновки базы распределения.
Функция СхемаБазыРаспределения(БазаРаспределения, МенеджерОбъекта = Неопределено) Экспорт
	
	Если МенеджерОбъекта = Неопределено Тогда
		МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоСсылке(БазаРаспределения);
	КонецЕсли;
	
	Возврат МенеджерОбъекта.ПолучитьМакет(ИмяСхемыБазыРаспределения(БазаРаспределения, МенеджерОбъекта));
	
КонецФункции

#Область РаботаСКомпоновщикомНастроек

// Проверяет есть ли установленный отбор в компоновщике настроек.
// Параметры:
//	НовыеНастройки - КомпоновщикНастроекКомпоновкиДанных - 
// Возвращаемое значение:
//	Булево - 
Функция ОтборУстановлен(НовыеНастройки) Экспорт
	
	ОтборУстановлен = Ложь;
	НастройкиКомпоновщика = НовыеНастройки.ПолучитьНастройки();
	Для Каждого ЭлементОтбора Из НастройкиКомпоновщика.Отбор.Элементы Цикл
		Если ЭлементОтбора.Использование Тогда
			
			ОтборУстановлен = Истина;
			Прервать;
			
		КонецЕсли;
	КонецЦикла;
	
	Возврат ОтборУстановлен;
	
КонецФункции

#КонецОбласти

#КонецОбласти