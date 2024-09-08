﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Обеспечение

// Получает оформленное накладными по заказам количество.
//
// Параметры:
//  ТаблицаОтбора		 - ТаблицаЗначений - Таблица с полями "Ссылка" и "КодСтроки", строки должны быть уникальными.
//  ОтборПоИзмерениям	 - Структура - ключ структуры определяет имя измерения, по которому будет накладываться отбор,
//  									а значение структуры - искомое значение.
//  ИсключитьЗаказ		 - Булево - Признак исключающий заказ из списка оформленных накладных.
//
// Возвращаемое значение:
//  ТаблицаЗначений - Таблица с полями "Ссылка", "КодСтроки", "Количество". Для каждой пары Заказ-КодСтроки содержит
//                    оформленное накладными количество.
//
Функция ТаблицаОформлено(ТаблицаОтбора, ОтборПоИзмерениям = Неопределено, ИсключитьЗаказ = Ложь) Экспорт

	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.Ссылка    КАК Ссылка,
		|	Таблица.КодСтроки КАК КодСтроки
		|ПОМЕСТИТЬ ВтОтбор
		|ИЗ
		|	&ТаблицаОтбора КАК Таблица
		|ГДЕ
		|	Таблица.КодСтроки > 0
		|;
		|
		|////////////////////////////////////////
		|ВЫБРАТЬ
		|	Отбор.КодСтроки КАК КодСтроки,
		|	Отбор.Ссылка    КАК Ссылка,
		|	МАКСИМУМ(РегистрЗаказы.Номенклатура)   КАК Номенклатура,
		|	МАКСИМУМ(РегистрЗаказы.Характеристика) КАК Характеристика,
		|	МАКСИМУМ(РегистрЗаказы.Склад)          КАК Склад,
		|	МАКСИМУМ(РегистрЗаказы.Серия)          КАК Серия,
		|	СУММА(РегистрЗаказы.КОформлению) КАК Количество
		|ИЗ
		|	ВтОтбор КАК Отбор
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ЗаказыНаВнутреннееПотребление КАК РегистрЗаказы
		|		ПО РегистрЗаказы.ЗаказНаВнутреннееПотребление = Отбор.Ссылка
		|		 И РегистрЗаказы.КодСтроки = Отбор.КодСтроки
		|		 И РегистрЗаказы.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|		 И РегистрЗаказы.КОформлению <> 0
		|		 И РегистрЗаказы.Активность
		|		 И &ОтборПереопределяемый
		|СГРУППИРОВАТЬ ПО
		|	Отбор.Ссылка, Отбор.КодСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаОтбора", ТаблицаОтбора);
	
	Отбор = Новый Массив;
	Если ИсключитьЗаказ Тогда
		Отбор.Добавить("РегистрЗаказы.ЗаказНаВнутреннееПотребление <> РегистрЗаказы.Регистратор");
	КонецЕсли;
	Если ЗначениеЗаполнено(ОтборПоИзмерениям) Тогда
		Для Каждого КлючЗначение Из ОтборПоИзмерениям Цикл
			Запрос.УстановитьПараметр(КлючЗначение.Ключ, КлючЗначение.Значение);
			Отбор.Добавить("РегистрЗаказы." + КлючЗначение.Ключ + " В(&" + КлючЗначение.Ключ + ")");
		КонецЦикла;
	КонецЕсли;
	Если ЗначениеЗаполнено(Отбор) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПереопределяемый", СтрСоединить(Отбор, " И "));
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ОтборПереопределяемый", "ИСТИНА");
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	Таблица = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	Таблица.Индексы.Добавить("Ссылка, КодСтроки");
	
	Возврат Таблица;
	
КонецФункции

#КонецОбласти

#Область Состояния

// Возвращает текст запроса для расчета количества товара которое осталось отгрузить.
// 
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ВременнаяТаблицаОстаткиЗаказов() Экспорт
	
	ТекстЗапроса =
		"ВЫБРАТЬ
		|	Таблица.ЗаказНаВнутреннееПотребление КАК Распоряжение,
		|	Таблица.ЗаказаноОстаток              КАК КоличествоЗаказано
		|ПОМЕСТИТЬ ВтОстаткиЗаказов
		|ИЗ
		|	РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(, ЗаказНаВнутреннееПотребление В(&МассивЗаказов)) КАК Таблица";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

// Текст запроса получает остаток по ресурсам КОформлению и Заказано
// Остаток дополняется движениями, сделанными накладной заданной в параметре Регистратор.
//
// Параметры:
//  ИмяВременнойТаблицы	 - Строка - Поместить результат во временную таблицу с заданным именем.
// 
// Возвращаемое значение:
//  Строка - текст запроса
//
Функция ТекстЗапросаОстатки(ИмяВременнойТаблицы) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Набор.ЗаказНаВнутреннееПотребление КАК ЗаказНаВнутреннееПотребление,
	|	Набор.Номенклатура                 КАК Номенклатура,
	|	Набор.Характеристика               КАК Характеристика,
	|	Набор.КодСтроки                    КАК КодСтроки,
	|	Набор.Серия                        КАК Серия,
	|	Набор.Склад                        КАК Склад,
	|	СУММА(Набор.Заказано)              КАК Заказано,
	|	СУММА(Набор.КОформлению)           КАК КОформлению
	|ПОМЕСТИТЬ ИмяТаблицыПереопределяемый
	|ИЗ(
	|	ВЫБРАТЬ
	|		Таблица.ЗаказНаВнутреннееПотребление КАК ЗаказНаВнутреннееПотребление,
	|		Таблица.Номенклатура                 КАК Номенклатура,
	|		Таблица.Характеристика               КАК Характеристика,
	|		Таблица.КодСтроки                    КАК КодСтроки,
	|		Таблица.Серия                        КАК Серия,
	|		Таблица.Склад                        КАК Склад,
	|		Таблица.ЗаказаноОстаток              КАК Заказано,
	|		Таблица.КОформлениюОстаток           КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыНаВнутреннееПотребление.Остатки(,
	|			ЗаказНаВнутреннееПотребление В(&Распоряжения)
	|				И (Склад В(&Склад) ИЛИ НЕ &ОтборПоСкладу)
	|			) КАК Таблица
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Таблица.ЗаказНаВнутреннееПотребление КАК ЗаказНаВнутреннееПотребление,
	|		Таблица.Номенклатура                 КАК Номенклатура,
	|		Таблица.Характеристика               КАК Характеристика,
	|		Таблица.КодСтроки                    КАК КодСтроки,
	|		Таблица.Серия                        КАК Серия,
	|		Таблица.Склад                        КАК Склад,
	|		Таблица.Заказано                     КАК Заказано,
	|		Таблица.КОформлению                  КАК КОформлению
	|	ИЗ
	|		РегистрНакопления.ЗаказыНаВнутреннееПотребление КАК Таблица
	|	ГДЕ
	|		Активность
	|		И Таблица.Регистратор = &Регистратор
	|		И Таблица.ВидДвижения = ЗНАЧЕНИЕ(ВидДВиженияНакопления.Расход)
	|		И Таблица.ЗаказНаВнутреннееПотребление В(&Распоряжения)
	|		И (Таблица.Склад В(&Склад)
	|			ИЛИ НЕ &ОтборПоСкладу)
	|	) КАК Набор
	|
	|СГРУППИРОВАТЬ ПО
	|	Набор.ЗаказНаВнутреннееПотребление,
	|	Набор.Номенклатура,
	|	Набор.Характеристика,
	|	Набор.КодСтроки,
	|	Набор.Серия,
	|	Набор.Склад
	|ИМЕЮЩИЕ
	|	СУММА(Набор.КОформлению) <> 0
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗаказНаВнутреннееПотребление, КодСтроки";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИмяТаблицыПереопределяемый", ИмяВременнойТаблицы);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ЗаказНаВнутреннееПотребление.Организация)
	|	И ЗначениеРазрешено(Склад)
	|	И ЗначениеРазрешено(ЗаказНаВнутреннееПотребление.Подразделение)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли