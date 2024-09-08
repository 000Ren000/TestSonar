﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Удаленное администрирование".
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП.

// Вызывается перед попыткой записи значений параметров ИБ в одноименные
// константы.
//
// Параметры:
// ЗначенияПараметров - Структура - значения параметров которые требуется установить.
// В случае если значение параметра устанавливается в данной процедуре из структуры
// необходимо удалить соответствующую пару КлючИЗначение.
//
Процедура ПриУстановкеЗначенийПараметровИБ(Знач ЗначенияПараметров) Экспорт
	
	Если ЗначенияПараметров.Свойство("ВнутреннийАдресМенеджераСервиса") Тогда
		
		РаботаВМоделиСервисаБТС.УстановитьВнутреннийАдресМенеджераСервиса(ЗначенияПараметров.ВнутреннийАдресМенеджераСервиса);
		ЗначенияПараметров.Удалить("ВнутреннийАдресМенеджераСервиса");
		
	КонецЕсли;
	
	Если ЗначенияПараметров.Свойство("URLСервиса") Тогда
		
		РаботаВМоделиСервисаБТС.УстановитьВнутреннийАдресМенеджераСервиса(ЗначенияПараметров.URLСервиса);
		ЗначенияПараметров.Удалить("URLСервиса");
		
	КонецЕсли;
	
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ВнутреннийАдресМенеджераСервиса");
	
	Если ЗначенияПараметров.Свойство("ИмяСлужебногоПользователяСервиса") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, 
			ЗначенияПараметров.ИмяСлужебногоПользователяСервиса, "ИмяСлужебногоПользователяМенеджераСервиса");
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗначенияПараметров.Удалить("ИмяСлужебногоПользователяСервиса");
		
	КонецЕсли;
	
	Если ЗначенияПараметров.Свойство("ПарольСлужебногоПользователяСервиса") Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, 
			ЗначенияПараметров.ПарольСлужебногоПользователяСервиса, "ПарольСлужебногоПользователяМенеджераСервиса");
		УстановитьПривилегированныйРежим(Ложь);
		
		ЗначенияПараметров.Удалить("ПарольСлужебногоПользователяСервиса");
		
	КонецЕсли;
	
	Если ЗначенияПараметров.Свойство("ИмяСлужебногоПользователяМенеджераСервиса") Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, 
			ЗначенияПараметров.ИмяСлужебногоПользователяМенеджераСервиса, "ИмяСлужебногоПользователяМенеджераСервиса");
		УстановитьПривилегированныйРежим(Ложь);
		ЗначенияПараметров.Удалить("ИмяСлужебногоПользователяМенеджераСервиса");
	КонецЕсли;
	
	Если ЗначенияПараметров.Свойство("ПарольСлужебногоПользователяМенеджераСервиса") Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(Владелец, 
			ЗначенияПараметров.ПарольСлужебногоПользователяМенеджераСервиса, "ПарольСлужебногоПользователяМенеджераСервиса");
		УстановитьПривилегированныйРежим(Ложь);
		ЗначенияПараметров.Удалить("ПарольСлужебногоПользователяМенеджераСервиса");
	КонецЕсли;
	
	Если ЗначенияПараметров.Свойство("АдресПровайдераАутентификации") Тогда
		РаботаВМоделиСервисаБТС.УстановитьАдресПровайдераАутентификации(ЗначенияПараметров.АдресПровайдераАутентификации);
		ЗначенияПараметров.Удалить("АдресПровайдераАутентификации");
	КонецЕсли;
	
	Если ЗначенияПараметров.Свойство("АутентификацияТокеномДоступаВнутреннихВызововПрограммногоИнтерфейса") Тогда
		РаботаВМоделиСервисаБТС.УстановитьАутентификацияТокеномДоступаВнутреннихВызововПрограммногоИнтерфейса(
			ЗначенияПараметров.АутентификацияТокеномДоступаВнутреннихВызововПрограммногоИнтерфейса);
		ЗначенияПараметров.Удалить("АутентификацияТокеномДоступаВнутреннихВызововПрограммногоИнтерфейса");
	КонецЕсли;
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  принимаемых сообщений.
//
// Параметры:
//  МассивОбработчиков - Массив из ОбщийМодуль - массив обработчиков. 
//
Процедура РегистрацияИнтерфейсовПринимаемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияУдаленногоАдминистрированияИнтерфейс);
	
КонецПроцедуры

// Заполняет переданный массив общими модулями, которые являются обработчиками интерфейсов
//  отправляемых сообщений.
//
// Параметры:
//  МассивОбработчиков - Массив из ОбщийМодуль - массив обработчиков.
//
//
Процедура РегистрацияИнтерфейсовОтправляемыхСообщений(МассивОбработчиков) Экспорт
	
	МассивОбработчиков.Добавить(СообщенияКонтрольУдаленногоАдминистрированияИнтерфейс);
	МассивОбработчиков.Добавить(СообщенияУправленияПриложениямиИнтерфейс);
	
КонецПроцедуры

#КонецОбласти
