﻿
#Область СлужебныйПрограммныйИнтерфейс

// Чеки в очереди на фискализацию.
//
// Параметры:
//  КассаККМ - ОпределяемыйТип.КассаБПО - Касса по которой провести фискализацию, если не указано тогда по всем.
//
// Возвращаемое значение:
//  Массив.
Функция ЧекиВОчередиНаФискализацию(КассаККМ = Неопределено) Экспорт
	
	Возврат РаспределеннаяФискализация.ЧекиВОчередиНаФискализацию(КассаККМ);
	
КонецФункции

// Записать статус чека в очереди.
//
// Параметры:
//  ПараметрыФискализации - Структура:
//   * ИдентификаторФискальнойЗаписи - Строка
//   * ДокументОснование - ДокументСсылка
//   * РезультатВыполненияПакетнойОперации - Структура
//  СтатусЧека - ПеречислениеСсылка.СтатусЧекаККТВОчереди
//  ОборудованиеККТ - СправочникСсылка.ПодключаемоеОборудование -
//  ТекстОшибки - Строка
Процедура ЗаписатьСтатусЧекаВОчереди(ПараметрыФискализации, СтатусЧека, ОборудованиеККТ = Неопределено, ТекстОшибки = Неопределено) Экспорт
	
	РаспределеннаяФискализация.ЗаписатьСтатусЧекаВОчереди(ПараметрыФискализации, СтатусЧека, ОборудованиеККТ, ТекстОшибки);
	
КонецПроцедуры

// Завершение фискализация чека в очереди
//
// Параметры:
//  РеквизитыЧека - Структура - Данные документа основания.
//  СтатусДокументаИзменен - Булево - признак изменения статуса документа.
//
Процедура ПроверитьСтатусДокументаОснования(РеквизитыЧека, СтатусДокументаИзменен) Экспорт
	
	РаспределеннаяФискализацияПереопределяемый.ПроверитьСтатусДокументаОснования(РеквизитыЧека, СтатусДокументаИзменен);
	
КонецПроцедуры

#КонецОбласти
