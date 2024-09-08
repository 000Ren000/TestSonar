﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.ДобавитьЗадание().
//
// Возвращаемое значение:
//   Неопределено - следует использовать РегламентныеЗаданияСервер.ДобавитьЗадание().
//
Функция СоздатьНовоеЗадание() Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.УникальныйИдентификатор().
//
// Параметры:
//   Задание - РегламентноеЗадание - регламентное задание.
//
// Возвращаемое значение:
//   Неопределено - следует использовать РегламентныеЗаданияСервер.УникальныйИдентификатор().
//
Функция ПолучитьИдентификаторЗадания(Знач Задание) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.ИзменитьЗадание().
//
// Параметры:
//   Задание - РегламентноеЗадание - регламентное задание.
//   Использование - Булево - флаг использования регламентного задания.
//   Параметры - Массив - параметры регламентного задания.
//   Расписание - РасписаниеРегламентногоЗадания - расписание регламентного задания.
//
Процедура УстановитьПараметрыЗадания(Задание, Использование, Параметры, Расписание) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Устарела. Следует использовать РегламентныеЗаданияСервер.НайтиЗадания().
//
// Параметры:
//   Задание - РегламентноеЗадание - регламентное задание.
//
// Возвращаемое значение:
//   Неопределено - следует использовать РегламентныеЗаданияСервер.НайтиЗадания().
//
Функция ПолучитьПараметрыЗадания(Знач Задание) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.Задание().
//
// Параметры:
//   Идентификатор - УникальныйИдентификатор - идентификатор регламентного задания.
//
// Возвращаемое значение:
//   Неопределено - следует использовать РегламентныеЗаданияСервер.НайтиЗадания().
//
Функция НайтиЗадание(Знач Идентификатор) Экспорт
	
	Возврат Неопределено;
	
КонецФункции

// Устарела. Следует использовать РегламентныеЗаданияСервер.УдалитьЗадание().
//
// Параметры:
//   Задание - РегламентноеЗадание - регламентное задание.
//
Процедура УдалитьЗадание(Знач Задание) Экспорт
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
