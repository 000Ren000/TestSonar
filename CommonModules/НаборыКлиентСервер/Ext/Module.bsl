﻿////////////////////////////////////////////////////////////////////////////////
// Модуль "НаборыВызовСервера", содержит процедуры и функции для
// работы с наборами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает список блокируемых элементов формы.
// 
// Параметры:
//  ИмяТЧ - Строка - Имя табличной части.
//
// Возвращаемое значение:
//  Массив - Массив блокируемых элементов.
//
Функция БлокируемыеЭлементы(ИмяТЧ = Неопределено) Экспорт
	
	БлокируемыеЭлементы = Новый Массив;
	
	ТабличныеЧасти = Новый Массив;
	Если ИмяТЧ = Неопределено Тогда
		ТабличныеЧасти.Добавить("Товары");
		ТабличныеЧасти.Добавить("Корзина");
		ТабличныеЧасти.Добавить("Услуги");
		ТабличныеЧасти.Добавить("ВозвращаемыеТовары");
		ТабличныеЧасти.Добавить("ЗаменяющиеТовары");
		ТабличныеЧасти.Добавить("КорзинаПокупателя");
		ТабличныеЧасти.Добавить("ТаблицаКорректировки");
	Иначе
		ТабличныеЧасти.Добавить(ИмяТЧ);
	КонецЕсли;
	
	Для Каждого ИмяТЧ Из ТабличныеЧасти Цикл
		
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "Номенклатура");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "Характеристика");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "Упаковка");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "НоменклатураЕдиницаИзмерения");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "Количество");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "КоличествоУпаковок");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "Цена");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "Сумма");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "СтавкаНДС");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "СуммаНДС");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "СуммаСНДС");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "ВидЦены");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "ИндексНабора");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "ПричинаОтмены");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "ОтмененоПричиныОтменыНеИспользуются");
		БлокируемыеЭлементы.Добавить(ИмяТЧ + "Отменено");
		
	КонецЦикла;
	
	Возврат БлокируемыеЭлементы;
	
КонецФункции

#Область ПечатныеФормы

// Возвращает Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
// за исключением наименования.
// 
// Параметры:
//  СтрокаТовары - СтрокаТабличнойЧасти - Строка товара.
//  ИспользоватьНаборы - Булево - Значение ФО ИспользоватьНаборы.
//
// Возвращаемое значение:
//  Булево - Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
//  за исключением наименования.
Функция ВыводитьТолькоЗаголовок(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Тогда
		Возврат ВыводитьТолькоЗаголовокНабора(СтрокаТовары, ИспользоватьНаборы)
	ИначеЕсли ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Тогда
		Возврат ВыводитьТолькоЗаголовокКомплектующих(СтрокаТовары, ИспользоватьНаборы)
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
// за исключением наименования и данная строка - Комплектующие набора.
// 
// Параметры:
//  СтрокаТовары - СтрокаТабличнойЧасти - Строка товара.
//  ИспользоватьНаборы - Булево - Значение ФО ИспользоватьНаборы.
//
// Возвращаемое значение:
//  Булево - Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
//  за исключением наименования и данная строка - Комплектующие набора.
Функция ВыводитьТолькоЗаголовокКомплектующих(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоКомплектующие
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = ПредопределенноеЗначение("Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие")
		И (    СтрокаТовары.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоДолям")
		   ИЛИ СтрокаТовары.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.ЦенаЗадаетсяЗаНаборРаспределяетсяПоЦенам"))
		Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
// за исключением наименования и данная строка - Набор.
// 
// Параметры:
//  СтрокаТовары - СтрокаТабличнойЧасти - Строка товара.
//  ИспользоватьНаборы - Булево - Значение ФО ИспользоватьНаборы.
//
// Возвращаемое значение:
//  Булево - Истина, если СтрокаТовара должна отображаться с пустыми данными в колонках
//  за исключением наименования и данная строка - Набор.
Функция ВыводитьТолькоЗаголовокНабора(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоНабор
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = ПредопределенноеЗначение("Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие")
		И СтрокаТовары.ВариантРасчетаЦеныНабора = ПредопределенноеЗначение("Перечисление.ВариантыРасчетаЦенНаборов.РассчитываетсяИзЦенКомплектующих")
		Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если область набора должна быть использована в печатной форме.
// 
// Параметры:
//  СтрокаТовары - СтрокаТабличнойЧасти - Строка товары.
//  ИспользоватьНаборы - Булево - Значение ФО ИспользоватьНаборы.
//
// Возвращаемое значение:
//  Булево - Истина, если область набора должна быть использована в печатной форме.
//
Функция ИспользоватьОбластьНабор(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоНабор
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = ПредопределенноеЗначение("Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если область комплектующих должна быть использована в печатной форме.
// 
// Параметры:
//  СтрокаТовары - СтрокаТабличнойЧасти - Строка товара.
//  ИспользоватьНаборы - Булево - Значение ФО ИспользоватьНаборы.
//
// Возвращаемое значение:
//  Булево - Истина, если область комплектующих должна быть использована в печатной форме.
//
Функция ИспользоватьОбластьКомплектующие(СтрокаТовары, ИспользоватьНаборы) Экспорт
	
	Если ИспользоватьНаборы
		И СтрокаТовары.ЭтоКомплектующие
		И СтрокаТовары.ВариантПредставленияНабораВПечатныхФормах = ПредопределенноеЗначение("Перечисление.ВариантыПредставленияНаборовВПечатныхФормах.НаборИКомплектующие") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти