﻿// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Параметры:
//  ИдентификаторУчетнойЗаписи - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ИдентификаторУчетнойЗаписи
//  ТипСинхронизации - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ТипСинхронизации
//  ДатаСинхронизации - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ДатаСинхронизации
Процедура Записать(ИдентификаторУчетнойЗаписи, ТипСинхронизации, ДатаСинхронизации) Экспорт
	НаборЗаписей = СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.ИдентификаторУчетнойЗаписи.Установить(ИдентификаторУчетнойЗаписи);
	НаборЗаписей.Отбор.ТипСинхронизации.Установить(ТипСинхронизации);
	ЗаписьНабора = НаборЗаписей.Добавить();
	ЗаписьНабора.ИдентификаторУчетнойЗаписи = ИдентификаторУчетнойЗаписи;
	ЗаписьНабора.ТипСинхронизации = ТипСинхронизации;
	ЗаписьНабора.ДатаСинхронизации = ДатаСинхронизации;
	НаборЗаписей.Записать();
КонецПроцедуры

// Параметры:
//  ИдентификаторыУчетныхЗаписей - Массив из см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ИдентификаторУчетнойЗаписи
// 
// Возвращаемое значение:
//  ТаблицаЗначений:
//  * ИдентификаторУчетнойЗаписи - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ИдентификаторУчетнойЗаписи
//  * ТипСинхронизации - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ТипСинхронизации
//  * ДатаСинхронизации - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ДатаСинхронизации
Функция Выгрузить(ИдентификаторыУчетныхЗаписей = Неопределено) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СостоянияСинхронизацииОблачногоЭДО.ИдентификаторУчетнойЗаписи,
		|	СостоянияСинхронизацииОблачногоЭДО.ТипСинхронизации,
		|	СостоянияСинхронизацииОблачногоЭДО.ДатаСинхронизации
		|ИЗ
		|	РегистрСведений.СостоянияСинхронизацииОблачногоЭДО КАК СостоянияСинхронизацииОблачногоЭДО";
	
	Если ЗначениеЗаполнено(ИдентификаторыУчетныхЗаписей) Тогда
		Запрос.Текст = Запрос.Текст + "
			|ГДЕ
			|	СостоянияСинхронизацииОблачногоЭДО.ИдентификаторУчетнойЗаписи В (&ИдентификаторыУчетныхЗаписей)";
		Запрос.УстановитьПараметр("ИдентификаторыУчетныхЗаписей", ИдентификаторыУчетныхЗаписей);
	КонецЕсли;
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Параметры:
//  ИдентификаторУчетнойЗаписи - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ИдентификаторУчетнойЗаписи
//  ТипСинхронизации - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ТипСинхронизации
// 
// Возвращаемое значение:
//  См. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ДатаСинхронизации
Функция ДатаСинхронизацииПоТипу(ИдентификаторУчетнойЗаписи, ТипСинхронизации) Экспорт
	
	Выборка = ВыборкаДатыСинхронизацииПоТипу(ИдентификаторУчетнойЗаписи, ТипСинхронизации);
	
	Если Выборка.Следующий() Тогда
		ДатаСинхронизации = Выборка.ДатаСинхронизации;
	Иначе
		ДатаСинхронизации = '00010101';
	КонецЕсли;
	
	Возврат ДатаСинхронизации;
	
КонецФункции

// Параметры:
//  ИдентификаторУчетнойЗаписи - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ИдентификаторУчетнойЗаписи
//  ТипСинхронизации - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ТипСинхронизации
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса:
//  * ДатаСинхронизации - см. РегистрСведений.СостоянияСинхронизацииОблачногоЭДО.ДатаСинхронизации
Функция ВыборкаДатыСинхронизацииПоТипу(ИдентификаторУчетнойЗаписи, ТипСинхронизации)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СостоянияСинхронизацииОблачногоЭДО.ДатаСинхронизации
		|ИЗ
		|	РегистрСведений.СостоянияСинхронизацииОблачногоЭДО КАК СостоянияСинхронизацииОблачногоЭДО
		|ГДЕ
		|	СостоянияСинхронизацииОблачногоЭДО.ИдентификаторУчетнойЗаписи = &ИдентификаторУчетнойЗаписи
		|	И СостоянияСинхронизацииОблачногоЭДО.ТипСинхронизации = &ТипСинхронизации";
		
	Запрос.УстановитьПараметр("ИдентификаторУчетнойЗаписи", ИдентификаторУчетнойЗаписи);
	Запрос.УстановитьПараметр("ТипСинхронизации", ТипСинхронизации);
	
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

#КонецЕсли
