﻿#Область ПрограммныйИнтерфейс

// Заполняет реквизит "Цена" в товарной табличной части.
//
// Параметры:
// 	ТабличнаяЧасть - ДанныеФормыКоллекция, ТабличнаяЧасть - Товарная табличная часть документа
// 	ВыделенныеСтроки - Массив, Неопределено - Массив выделенных строк, если Неопределено, то будут заполнены ВСЕ строки
// 	ПараметрыЗаполнения - см. НовыйПараметрыЗаполненияЗаполнитьЦены
// 	СтруктураДействий - см. ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ.СтруктураДействий
// 	КэшированныеЗначения - Структура - Структура кэшированных значений.
// 		
// Возвращаемое значение:
//   Булево - Истина, если цены успешно заполнены.
//
Функция ЗаполнитьЦены(
	ТабличнаяЧасть, 
	ВыделенныеСтроки, 
	ПараметрыЗаполнения, 
	СтруктураДействий = Неопределено, 
	КэшированныеЗначения = Неопределено) Экспорт
	
	ЦеныЗаполнены = Ложь;
	
	Если ПараметрыЗаполнения = Неопределено Тогда
		ВызватьИсключение НСтр("ru = 'Параметры заполнения не указаны'");
	КонецЕсли;
	
	// Получение структуры параметров по умолчанию
	Параметры = НовыйПараметрыЗаполненияЗаполнитьЦены();
	
	ОбщегоНазначенияУТКлиентСервер.ДополнитьСтруктуру(Параметры, ПараметрыЗаполнения, Истина);
	
	// Проверки входящих данных
	Если Не ЗначениеЗаполнено(Параметры.Соглашение) И Не ЗначениеЗаполнено(Параметры.ВидЦеныПоставщика) Тогда
		Если СтрНайти(ПараметрыЗаполнения.ПоляЗаполнения, "СтавкаНДС") = 0 Тогда
			Возврат Ложь;
		КонецЕсли;
	ИначеЕсли Не ЗначениеЗаполнено(Параметры.Дата) Или Не ЗначениеЗаполнено(Параметры.Валюта) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ВидЦеныПоставщика = Справочники.ВидыЦенПоставщиков.ПустаяСсылка();
	Если ЗначениеЗаполнено(Параметры.Соглашение) И Не ЗначениеЗаполнено(ПараметрыЗаполнения.ВидЦеныПоставщика) Тогда
		ВидЦеныПоставщика = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Параметры.Соглашение, "ВидЦеныПоставщика");
	Иначе
		ВидЦеныПоставщика = Параметры.ВидЦеныПоставщика;
	КонецЕсли;
	
	Соглашение = Параметры.Соглашение;
	
	// Получение выгрузки по табличной части
	ЕстьУпаковка = Ложь;
	Если ТипЗнч(ТабличнаяЧасть) = Тип("ТаблицаЗначений") Тогда
		ЕстьУпаковка = ТабличнаяЧасть.Колонки.Найти("Упаковка") <> Неопределено;
	Иначе
		ЕстьУпаковка = ТабличнаяЧасть.Выгрузить(Новый Массив).Колонки.Найти("Упаковка") <> Неопределено;
	КонецЕсли;
	
	Если ЕстьУпаковка Тогда
		КолонкиТаблицы = "НомерСтроки, Номенклатура, Характеристика, Упаковка";
	Иначе
		КолонкиТаблицы = "НомерСтроки, Номенклатура, Характеристика";
	КонецЕсли;
	
	Таблица = ОбщегоНазначенияУТ.ВыгрузитьТаблицуЗначений(
		ТабличнаяЧасть,
		ВыделенныеСтроки,
		КолонкиТаблицы,
		Параметры.КолонкиПоЗначению,
		Параметры.ДругиеИменаКолонок);
	
	Если Не ЕстьУпаковка Тогда
		Таблица.Колонки.Добавить("Упаковка", Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	КонецЕсли;
	
	// Получение запроса
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Параметры.Дата), Параметры.Дата, ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("Валюта", Параметры.Валюта);
	Запрос.УстановитьПараметр("Соглашение", Соглашение);
	Запрос.УстановитьПараметр("ВидЦеныПоставщика", ВидЦеныПоставщика);
	Запрос.УстановитьПараметр("НалогообложениеНДС", ?(Параметры.Свойство("НалогообложениеНДС"), Параметры.НалогообложениеНДС, Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка()));
	Запрос.УстановитьПараметр("ВернутьМногооборотнуюТару", ?(Параметры.Свойство("ВернутьМногооборотнуюТару"), Параметры.ВернутьМногооборотнуюТару, Ложь));
	Запрос.УстановитьПараметр("Таблица", Таблица);
	
	Если ЗначениеЗаполнено(Параметры.Организация) Тогда
		Запрос.УстановитьПараметр("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.СтранаРегистрацииОрганизации(Параметры.Организация));
	Иначе
		Запрос.УстановитьПараметр("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана());
	КонецЕсли;
	
	Запрос.Текст = ПолучитьТекстЗапросаВременнойТаблицыТоваров("втТаблицаТовары")
	             + ПолучитьТекстЗапросаВременнойТаблицыЦен("втТаблицаЦены", "втТаблицаТовары", Запрос.Параметры)
	             + "ВЫБРАТЬ
	               |	втТаблицаЦены.НомерСтроки КАК НомерСтроки,
	               |	втТаблицаЦены.ВидЦеныПоставщика КАК ВидЦеныПоставщика,
	               |	втТаблицаЦены.СтавкаНДС КАК СтавкаНДС,
	               |	втТаблицаЦены.Цена
	               |ИЗ
	               |	втТаблицаЦены КАК втТаблицаЦены";
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат ЦеныЗаполнены;
	КонецЕсли;
	
	СтруктураЗаполнения = Новый Структура(Параметры.ПоляЗаполнения);
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(СтруктураЗаполнения, Выборка);
		СтрокаТЧ = ТабличнаяЧасть[Выборка.НомерСтроки - 1];
		ЗаполнитьЗначенияСвойств(СтрокаТЧ, СтруктураЗаполнения);
		Если СтруктураДействий <> Неопределено Тогда
			ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(СтрокаТЧ, СтруктураДействий, КэшированныеЗначения);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

// Возвращает данные цен поставщика для переданных строк.
//
// Параметры:
//	Таблица - ТаблицаЗначений - со следующими полями:
//		* НомерСтроки       - Число -
//		* Номенклатура      - СправочникСсылка.Номенклатура -
//		* Характеристика    - СправочникСсылка.ХарактеристикиНоменклатуры -
//		* Упаковка          - СправочникСсылка.УпаковкиЕдиницыИзмерения - 
//		* ВидЦеныПоставщика - ПеречислениеСсылка.ТипыНалогообложенияНДС -
//	ПараметрыПолученияЦен - см. НовыйПараметрыПолученияЦенНоменклатурыПартнера 
//
// Возвращаемое значение:
// 	РезультатЗапроса - результат запроса со следующими полями:
// 		* НомерСтроки - Число - 
// 		* ставкаНДС   - СправочникСсылка.СтавкиНДС - 
// 		* Цена        - Число - 
//
Функция ЦеныНоменклатурыПартнера(Таблица, ПараметрыПолученияЦен) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Таблица",                      Таблица);
	Запрос.УстановитьПараметр("Дата",                         ПараметрыПолученияЦен.Дата);
	Запрос.УстановитьПараметр("Валюта",                       ПараметрыПолученияЦен.Валюта);
	Запрос.УстановитьПараметр("НалогообложениеНДС",           ПараметрыПолученияЦен.НалогообложениеНДС);
	Запрос.УстановитьПараметр("ВозвращатьМногооборотнуюТару", ПараметрыПолученияЦен.ВозвращатьМногооборотнуюТару);
	Запрос.УстановитьПараметр("БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию());
	Запрос.УстановитьПараметр("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана());
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Таблица.НомерСтроки           КАК НомерСтроки,
		|	Таблица.Номенклатура          КАК Номенклатура,
		|	Таблица.Характеристика        КАК Характеристика,
		|	Таблица.Упаковка              КАК Упаковка,
		|	ВЫРАЗИТЬ(Таблица.ВидЦеныПоставщика КАК Справочник.ВидыЦенПоставщиков) КАК ВидЦеныПоставщика
		|ПОМЕСТИТЬ втТаблицаТоварыПред
		|ИЗ
		|	&Таблица КАК Таблица
		|;
		|
		|/////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Таблица.НомерСтроки           КАК НомерСтроки,
		|	Таблица.Номенклатура          КАК Номенклатура,
		|	Таблица.Характеристика        КАК Характеристика,
		|	Таблица.Упаковка              КАК Упаковка,
		|	Таблица.ВидЦеныПоставщика     КАК ВидЦеныПоставщика,
		|	Таблица.ВидЦеныПоставщика.Владелец КАК Партнер
		|ПОМЕСТИТЬ втТаблицаТовары
		|ИЗ
		|	втТаблицаТоварыПред КАК Таблица
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика,
		|	ВидЦеныПоставщика,
		|	Партнер
		|;
		|
		|/////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦеныНоменклатурыПоставщиков.Номенклатура              КАК Номенклатура,
		|	ЦеныНоменклатурыПоставщиков.Характеристика            КАК Характеристика,
		|	ЦеныНоменклатурыПоставщиков.ВидЦеныПоставщика         КАК ВидЦеныПоставщика,
		|	ЦеныНоменклатурыПоставщиков.Валюта                    КАК Валюта,
		|	ЦеныНоменклатурыПоставщиков.Упаковка                  КАК Упаковка,
		|	ЦеныНоменклатурыПоставщиков.Цена                      КАК Цена
		|ПОМЕСТИТЬ ЦеныНоменклатурыПоставщиковСрезПоследних
		|ИЗ
		|	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
		|				(Номенклатура, Характеристика, ВидЦеныПоставщика, Партнер) В
		|				(ВЫБРАТЬ
		|					ВременнаяТаблицаТовары.Номенклатура,
		|					ВременнаяТаблицаТовары.Характеристика,
		|					ВременнаяТаблицаТовары.ВидЦеныПоставщика,
		|					ВременнаяТаблицаТовары.Партнер
		|				ИЗ
		|					втТаблицаТовары КАК ВременнаяТаблицаТовары)
		|) КАК ЦеныНоменклатурыПоставщиков
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Номенклатура,
		|	Характеристика,
		|	ВидЦеныПоставщика,
		|	Валюта
		|;
		|
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
		|	ВЫБОР
		|		КОГДА
		|			&ВозвращатьМногооборотнуюТару 
		|			И ВременнаяТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
		|		ТОГДА
		|			ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
		|		КОГДА &НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС)
		|			ИЛИ &НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка)
		|		ТОГДА
		|			ЕСТЬNULL(СтавкиНДСНоменклатуры.СтавкаНДС, ЕСТЬNULL(ОсновныеСтавкиНДС.СтавкаНДС, ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)))
		|		ИНАЧЕ
		|			ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
		|	КОНЕЦ КАК СтавкаНДС,
		|	ВЫБОР
		|		КОГДА
		|			ВременнаяТаблицаТовары.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|		ТОГДА
		|			&ТекстЗапросаКоэффициентУпаковки1
		|		ИНАЧЕ
		|			1
		|	КОНЕЦ
		|	* ЦеныНоменклатурыПоставщиковСрезПоследних.Цена/ЕстьNULL(&ТекстЗапросаКоэффициентУпаковки2,1)
		|	* ВЫБОР
		|		КОГДА &Валюта <> ЦеныНоменклатурыПоставщиковСрезПоследних.Валюта
		|			ТОГДА ВЫБОР
		|					КОГДА ЕСТЬNULL(КурсыВалютыЦены.КурсЗнаменатель, 0) > 0
		|						И ЕСТЬNULL(КурсыВалютыЦены.КурсЧислитель, 0) > 0
		|						И ЕСТЬNULL(КурсыВалюты.КурсЗнаменатель, 0) > 0
		|						И ЕСТЬNULL(КурсыВалюты.КурсЧислитель, 0) > 0
		|					ТОГДА 
		|						(КурсыВалютыЦены.КурсЧислитель * КурсыВалюты.КурсЗнаменатель)
		|						/ (КурсыВалюты.КурсЧислитель * КурсыВалютыЦены.КурсЗнаменатель)
		|					ИНАЧЕ 0
		|				КОНЕЦ
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Цена
		|ИЗ
		| втТаблицаТовары КАК ВременнаяТаблицаТовары
		|
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	ЦеныНоменклатурыПоставщиковСрезПоследних КАК ЦеныНоменклатурыПоставщиковСрезПоследних
		|ПО
		|	ВременнаяТаблицаТовары.Номенклатура = ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура
		|	И ВременнаяТаблицаТовары.Характеристика = ЦеныНоменклатурыПоставщиковСрезПоследних.Характеристика
		|	И ВременнаяТаблицаТовары.ВидЦеныПоставщика = ЦеныНоменклатурыПоставщиковСрезПоследних.ВидЦеныПоставщика
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалютыЦены
		|ПО 
		|	ЦеныНоменклатурыПоставщиковСрезПоследних.Валюта = КурсыВалютыЦены.Валюта
		|	
		|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта И БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалюты
		|	ПО ИСТИНА
		|
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНДСНоменклатуры.СрезПоследних(&Дата, Страна = &СтранаРегистрации) КАК СтавкиНДСНоменклатуры
		|	ПО ВременнаяТаблицаТовары.Номенклатура = СтавкиНДСНоменклатуры.Номенклатура
		|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСтавкиНДС.СрезПоследних(&Дата, Страна = &СтранаРегистрации) КАК ОсновныеСтавкиНДС
		|	ПО Истина
		|;
		|";
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ВременнаяТаблицаТовары.Упаковка",
		"ВременнаяТаблицаТовары.Номенклатура"));
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,
		"&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ЦеныНоменклатурыПоставщиковСрезПоследних.Упаковка",
		"ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура"));
		
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Возвращает цену по переданному отбору.
//
// Параметры:
//		ПараметрыОтбора - см. НовыйПараметрыОтбораПолучитьЦенуПоОтбору 
//
// Возвращаемое значение:
// 		Число - Цена
//
Функция ПолучитьЦенуПоОтбору(ПараметрыОтбора) Экспорт
	
	Запрос = Новый Запрос;
	Для Каждого Параметр Из ПараметрыОтбора Цикл
		Запрос.УстановитьПараметр(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ПараметрыОтбора.Организация) Тогда
		Запрос.УстановитьПараметр("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.СтранаРегистрацииОрганизации(ПараметрыОтбора.Организация));
	Иначе
		Запрос.УстановитьПараметр("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана());
	КонецЕсли;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК НомерСтроки,
	|	Номенклатура.Ссылка КАК Номенклатура,
	|	ВЫРАЗИТЬ(&Характеристика КАК Справочник.ХарактеристикиНоменклатуры) КАК Характеристика,
	|	ВЫРАЗИТЬ(&Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения) КАК Упаковка
	|ПОМЕСТИТЬ втТаблицаТовары
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.Ссылка = &Номенклатура
	|;" + ПолучитьТекстЗапросаВременнойТаблицыЦен("втТаблицаЦен", "втТаблицаТовары", Запрос.Параметры) + "
	|ВЫБРАТЬ
	|	втТаблицаЦен.Цена КАК Цена
	|ИЗ
	|	втТаблицаЦен КАК втТаблицаЦен
	|";
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	Выборка = Результат.Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Цена;
	КонецЕсли;
	
КонецФункции

#Область Конструкторы

// Конструктор метода ЦеныНоменклатурыПартнера(). 
// 
// Возвращаемое значение:
// 		Структура - : 
// 			* Дата - Дата -
// 			* Валюта - СправочникСсылка.Валюты -
// 			* НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС - ао-умолчанию, пустая ссылка.
// 			* ВозвращатьМногооборотнуюТару - Булево - по-умолчанию, Ложь 
//
Функция НовыйПараметрыПолученияЦенНоменклатурыПартнера() Экспорт
	
	ПараметрыПолученияЦен = Новый Структура();
	ПараметрыПолученияЦен.Вставить("Дата", Дата(1,1,1));
	ПараметрыПолученияЦен.Вставить("Валюта",ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	ПараметрыПолученияЦен.Вставить("НалогообложениеНДС", 
		ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПустаяСсылка"));
	ПараметрыПолученияЦен.Вставить("ВозвращатьМногооборотнуюТару", Ложь);
		
	Возврат ПараметрыПолученияЦен;

КонецФункции

// Функция-конструктор структуры отбора для получения цены, используется для получения атомарного значения цены.
// Используется как параметр метода ЦеныПартнеровЗаполнениеСервер.ПолучитьЦенуПоОтбору().  
// 
// Возвращаемое значение:
//	Структура - Структура параметров заполнения поля отбора. (сначала общие поля) :
//		общие поля. 
//			* Дата - Дата - дата, на которую необходимо получение цены.
//			* Валюта - СправочникСсылка.Валюты -
//			* Номенклатура - СправочникСсылка.Номенклатура -
//			* Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры -
//			* Упаковка - СправочникСсылка.УпаковкиЕдиницыИзмерения -
//			* ВидЦеныПоставщика - СправочникСсылка.ВидыЦенПоставщиков -
//			* Соглашение - СправочникСсылка.СоглашенияСПоставщиками -
//			* НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС -
//			* ВернутьМногооборотнуюТару - Булево - признак необходимости возврата многооборотной тары.
//
Функция НовыйПараметрыОтбораПолучитьЦенуПоОтбору() Экспорт
	
	СтруктураПараметровОтбора = Новый Структура;
	СтруктураПараметровОтбора.Вставить("Дата",Дата(1,1,1));
	СтруктураПараметровОтбора.Вставить("Организация",Справочники.Организации.ПустаяСсылка());
	СтруктураПараметровОтбора.Вставить("Валюта",Справочники.Валюты.ПустаяСсылка());
	СтруктураПараметровОтбора.Вставить("Номенклатура",Справочники.Номенклатура.ПустаяСсылка());
	СтруктураПараметровОтбора.Вставить("Характеристика",Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
	СтруктураПараметровОтбора.Вставить("Упаковка",Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка());
	СтруктураПараметровОтбора.Вставить("ВидЦеныПоставщика",Справочники.ВидыЦенПоставщиков.ПустаяСсылка());
	СтруктураПараметровОтбора.Вставить("Соглашение",Справочники.СоглашенияСПоставщиками.ПустаяСсылка());
	СтруктураПараметровОтбора.Вставить("НалогообложениеНДС",Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка());
	СтруктураПараметровОтбора.Вставить("ВернутьМногооборотнуюТару",Ложь);
	
	Возврат СтруктураПараметровОтбора; 
	
КонецФункции	

// Конструктор параметров метода ЗаполнитьЦены.
//
// Возвращаемое значение:
// 	Структура - Структура параметров заполнения:
//		Обязательные поля.
//			* Дата - Дата - Дата документа
//			* Валюта - СправочникСсылка.Валюты - Валюта документа
//			* Соглашение - СправочникСсылка.СоглашенияСПоставщиками - Соглашение документа
//					если ключ отсутствует, значит должен быть заполнен параметр "ВидЦеныПоставщика".
//			* ВидЦеныПоставщика - СправочникСсылка.ВидыЦенПоставщиков - Вид цены поставщика
//					если параметр отсутствует, значит должен быть заполнен параметр "Соглашение".
//		Необязательные поля.
// 			* ПоляЗаполнения - Строка - Строка с перечислением заполняемых полей в таблице; 
// 					значение по умолчанию: "Цена"; дополнительные поля - "ВидЦеныПоставщика, СтавкаНДС".
// 			* КолонкиПоЗначению - см. ОбщегоНазначенияУТ.ВыгрузитьТаблицуЗначений.КолонкиПоЗначению
// 			* ДругиеИменаКолонок - см. ОбщегоНазначенияУТ.ВыгрузитьТаблицуЗначений.НовыеИменаКолонок
// 			* НалогообложениеНДС - ПеречислениеСсылка.ТипыНалогообложенияНДС -  
//
Функция НовыйПараметрыЗаполненияЗаполнитьЦены() Экспорт
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("Дата",Дата(1,1,1));
	СтруктураПараметров.Вставить("Организация", ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка"));
	СтруктураПараметров.Вставить("Валюта", ПредопределенноеЗначение("Справочник.Валюты.ПустаяСсылка"));
	СтруктураПараметров.Вставить("Соглашение", 
		ПредопределенноеЗначение("Справочник.СоглашенияСПоставщиками.ПустаяСсылка"));
	СтруктураПараметров.Вставить("ВидЦеныПоставщика",
		ПредопределенноеЗначение("Справочник.ВидыЦенПоставщиков.ПустаяСсылка"));
	СтруктураПараметров.Вставить("ПоляЗаполнения", "Цена");
	СтруктураПараметров.Вставить("КолонкиПоЗначению", Новый Структура);
	СтруктураПараметров.Вставить("ДругиеИменаКолонок", Новый Структура);
	СтруктураПараметров.Вставить("НалогообложениеНДС", Перечисления.ТипыНалогообложенияНДС.ПустаяСсылка());
	
	Возврат СтруктураПараметров; 
	
КонецФункции

#КонецОбласти

#Область ПакетнаяОбработкаТабличныхЧастей

// Добавляет запрос в пакет запросов для получения данных, необходимых для получения цены закупки.
//
// Параметры:
//  СтруктураДействий - см. ПакетнаяОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения
//  ОписаниеЗапроса - см. ПакетнаяОбработкаТабличнойЧастиСервер.ОписаниеЗапроса
//  КэшированныеЗначения - Структура
//
Процедура ДополнитьТекстЗапросаЗаполнитьЦенуЗакупки(СтруктураДействий, ОписаниеЗапроса, КэшированныеЗначения) Экспорт
	
	Перем ПараметрыДействия;
	
	Если ПакетнаяОбработкаТабличнойЧастиСервер.ТребуетсяВыполнитьДействие(
			"ЗаполнитьЦенуЗакупки",
			СтруктураДействий,
			КэшированныеЗначения,
			ПараметрыДействия) Тогда
		
		ТекстыЗапросов = ТекстыЗапросовЗаполненияЦенПакетнаяОбработка(ПараметрыДействия);
		Для Каждого Запрос Из ТекстыЗапросов Цикл
			ОписаниеЗапроса.ТекстыЗапросов.Добавить(Запрос.Значение, Запрос.Представление);
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ПараметрыДействия.Организация) Тогда
			ОписаниеЗапроса.ПараметрыЗапроса.Вставить("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.СтранаРегистрацииОрганизации(ПараметрыДействия.Организация));
		Иначе
			ОписаниеЗапроса.ПараметрыЗапроса.Вставить("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана());
		КонецЕсли;
		
		Для Каждого Параметр Из ПараметрыДействия Цикл
			ОписаниеЗапроса.ПараметрыЗапроса.Вставить(Параметр.Ключ, Параметр.Значение);
		КонецЦикла;
		
		ОписаниеЗапроса.ПараметрыЗапроса.Вставить("БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию());
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет запрос в пакет запросов для получения данных, необходимых для получения условий закупок.
//
// Параметры:
//  СтруктураДействий - см. ПакетнаяОбработкаТабличнойЧастиКлиентСервер.ПолучитьСтруктуруКэшируемыеЗначения
//  ОписаниеЗапроса - см. ПакетнаяОбработкаТабличнойЧастиСервер.ОписаниеЗапроса
//  КэшированныеЗначения - Структура
//
Процедура ДополнитьТекстЗапросаЗаполнитьУсловияЗакупок(СтруктураДействий, ОписаниеЗапроса, КэшированныеЗначения) Экспорт
	
	Перем ПараметрыДействия;
	
	Если ПакетнаяОбработкаТабличнойЧастиСервер.ТребуетсяВыполнитьДействие(
			"ЗаполнитьУсловияЗакупок",
			СтруктураДействий,
			КэшированныеЗначения,
			ПараметрыДействия) Тогда
		
		ТекстыЗапросов = ТекстыЗапросовЗаполненияУсловийЗакупокПакетнаяОбработка(ПараметрыДействия);
		Для Каждого Запрос Из ТекстыЗапросов Цикл
			ОписаниеЗапроса.ТекстыЗапросов.Добавить(Запрос.Значение, Запрос.Представление);
		КонецЦикла;
		
		Если ЗначениеЗаполнено(ПараметрыДействия.Организация) Тогда
			ОписаниеЗапроса.ПараметрыЗапроса.Вставить("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.СтранаРегистрацииОрганизации(ПараметрыДействия.Организация));
		Иначе
			ОписаниеЗапроса.ПараметрыЗапроса.Вставить("СтранаРегистрации", ЗначениеНастроекКлиентСерверПовтИсп.ОсновнаяСтрана());
		КонецЕсли;
		
		Для Каждого Параметр Из ПараметрыДействия Цикл
			ОписаниеЗапроса.ПараметрыЗапроса.Вставить(Параметр.Ключ, Параметр.Значение);
		КонецЦикла;
		
		ОписаниеЗапроса.ПараметрыЗапроса.Вставить("БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию());
	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает текст запроса временной таблицы товаров
//
// Параметры:
// 		ИмяТаблицы - Строка - Строка имени для временной таблицы.
//
// Возвращаемое значение:
// 		Строка - Текст запроса временной таблицы.
//
Функция ПолучитьТекстЗапросаВременнойТаблицыТоваров(ИмяТаблицы)
	
	ТекстЗапроса =  "
	|ВЫБРАТЬ
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Упаковка КАК Упаковка
	|ПОМЕСТИТЬ ИмяТаблицы
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяТаблицы", "ПОМЕСТИТЬ " + ИмяТаблицы);
	
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса временной таблицы цен товаров по номерам строк
//
// Параметры:
// 		ИмяТаблицы - Строка - Строка имени для временной таблицы
// 		ИмяВременнойТаблицыТоваров - Строка - Строка имени временной таблицы товаров
// 		ВидЦенКакПараметр - Булево - Истина, если в запросе "ВидЦен" должен использоваться как параметр; Ложь - если как поле временной таблицы товаров.
//
// Возвращаемое значение:
// 		Строка - Текст запроса временной таблицы.
//
Функция ПолучитьТекстЗапросаВременнойТаблицыЦен(ИмяТаблицы, ИмяВременнойТаблицыТоваров, ПараметрыЗапроса)
	
	ПараметрыЗапроса.Вставить("БазоваяВалюта", ЗначениеНастроекПовтИсп.БазоваяВалютаПоУмолчанию());
	ПараметрыЗапроса.Вставить("Партнер", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыЗапроса.ВидЦеныПоставщика, "Владелец"));
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ЦеныНоменклатурыПоставщиков.Номенклатура              КАК Номенклатура,
	|	ЦеныНоменклатурыПоставщиков.Характеристика            КАК Характеристика,
	|	ЦеныНоменклатурыПоставщиков.Валюта                    КАК Валюта,
	|	ЦеныНоменклатурыПоставщиков.ВидЦеныПоставщика         КАК ВидЦеныПоставщика,
	|	ЦеныНоменклатурыПоставщиков.Упаковка                  КАК Упаковка,
	|	ЦеныНоменклатурыПоставщиков.Цена                      КАК Цена
	|ПОМЕСТИТЬ ЦеныНоменклатурыПоставщиковСрезПоследних
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),
	|				Партнер = &Партнер И
	|				ВидЦеныПоставщика = &ВидЦеныПоставщика И
	|				(Номенклатура, Характеристика) В
	|				(ВЫБРАТЬ
	|					ВременнаяТаблицаТовары.Номенклатура,
	|					ВременнаяТаблицаТовары.Характеристика
	|				ИЗ
	|					&ИмяВременнойТаблицыТоваров КАК ВременнаяТаблицаТовары)
	|) КАК ЦеныНоменклатурыПоставщиков
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Валюта
	|;
	|
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВременнаяТаблицаТовары.НомерСтроки КАК НомерСтроки,
	|	&ВидЦеныПоставщика КАК ВидЦеныПоставщика,
	|	ВЫБОР
	|		КОГДА
	|			&ВернутьМногооборотнуюТару = ИСТИНА
	|			И ВременнаяТаблицаТовары.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|		ТОГДА
	|			ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
	|		КОГДА &НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС)
	|			ТОГДА ЕСТЬNULL(СтавкиНДСНоменклатуры.СтавкаНДС, ЕСТЬNULL(ОсновныеСтавкиНДС.СтавкаНДС, ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)))
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
	|	КОНЕЦ КАК СтавкаНДС,
	|	ВЫБОР
	|		КОГДА
	|			ВременнаяТаблицаТовары.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|		ТОГДА
	|			&ТекстЗапросаКоэффициентУпаковки1
	|		ИНАЧЕ
	|			1
	|	КОНЕЦ
	|	* ЕСТЬNULL(ЦеныНоменклатурыПоставщиковСрезПоследних.Цена, 0)/ЕстьNULL(&ТекстЗапросаКоэффициентУпаковки2,1)
	|	* ВЫБОР
	|		КОГДА &Валюта <> ЦеныНоменклатурыПоставщиковСрезПоследних.Валюта
	|			ТОГДА ВЫБОР
	|					КОГДА ЕСТЬNULL(КурсыВалютыЦены.КурсЗнаменатель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалютыЦены.КурсЧислитель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалюты.КурсЗнаменатель, 0) > 0
	|						И ЕСТЬNULL(КурсыВалюты.КурсЧислитель, 0) > 0
	|					ТОГДА 
	|						(КурсыВалютыЦены.КурсЧислитель * КурсыВалюты.КурсЗнаменатель)
	|						/ (КурсыВалюты.КурсЧислитель * КурсыВалютыЦены.КурсЗнаменатель)
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Цена
	|ПОМЕСТИТЬ ИмяТаблицы
	|ИЗ
	| &ИмяВременнойТаблицыТоваров КАК ВременнаяТаблицаТовары
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	ЦеныНоменклатурыПоставщиковСрезПоследних КАК ЦеныНоменклатурыПоставщиковСрезПоследних
	|ПО
	|	ВременнаяТаблицаТовары.Номенклатура = ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура
	|	И ВременнаяТаблицаТовары.Характеристика = ЦеныНоменклатурыПоставщиковСрезПоследних.Характеристика
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалютыЦены
	|ПО 
	|	ЦеныНоменклатурыПоставщиковСрезПоследних.Валюта = КурсыВалютыЦены.Валюта
	|	
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта И БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалюты
	|	По Истина
	|	
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНДСНоменклатуры.СрезПоследних(&Дата,
	|		Страна = &СтранаРегистрации ИЛИ Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка)) КАК СтавкиНДСНоменклатуры
	|	ПО ВременнаяТаблицаТовары.Номенклатура = СтавкиНДСНоменклатуры.Номенклатура
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСтавкиНДС.СрезПоследних(&Дата, Страна = &СтранаРегистрации) КАК ОсновныеСтавкиНДС
	|	ПО Истина
	|;
	|";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПОМЕСТИТЬ ИмяТаблицы", "ПОМЕСТИТЬ " + ИмяТаблицы);

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяВременнойТаблицыТоваров", ИмяВременнойТаблицыТоваров);
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ВременнаяТаблицаТовары.Упаковка",
		"ВременнаяТаблицаТовары.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"ЦеныНоменклатурыПоставщиковСрезПоследних.Упаковка",
		"ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура"));
		
	Возврат ТекстЗапроса
	
КонецФункции

#Область ПакетнаяОбработкаТабличныхЧастейСлужебная

// Получить тексты запросов получения цен закупки.
//
// Параметры:
// 	ПараметрыДействия - Структура - параметры получения цен закупки.
//
// Возвращаемое значение:
// 	СписокЗначений Из Строка - тексты запросов получения цен для вставки.
//
Функция ТекстыЗапросовЗаполненияЦенПакетнаяОбработка(ПараметрыДействия) Экспорт
	
	Результат = Новый СписокЗначений();
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВтИсточникДанных.ИдентификаторСтрокиВТ КАК ИдентификаторСтрокиВТ,
	|	ВЫБОР
	|		КОГДА &ВернутьМногооборотнуюТару = ИСТИНА
	|		И ВтИсточникДанных.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
	|		КОГДА &НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС)
	|			ТОГДА ЕСТЬNULL(СтавкиНДСНоменклатуры.СтавкаНДС, ЕСТЬNULL(ОсновныеСтавкиНДС.СтавкаНДС,
	|				ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)))
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
	|	КОНЕЦ КАК СтавкаНДС,
	|	ВЫБОР
	|		КОГДА ВтИсточникДанных.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА &ТекстЗапросаКоэффициентУпаковки1
	|		ИНАЧЕ 1
	|	КОНЕЦ * ЕСТЬNULL(ЦеныНоменклатурыПоставщиковСрезПоследних.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) *
	|		ВЫБОР
	|		КОГДА &Валюта <> ЦеныНоменклатурыПоставщиковСрезПоследних.Валюта
	|			ТОГДА ВЫБОР
	|				КОГДА ЕСТЬNULL(КурсыВалютыЦены.КурсЗнаменатель, 0) > 0
	|				И ЕСТЬNULL(КурсыВалютыЦены.КурсЧислитель, 0) > 0
	|				И ЕСТЬNULL(КурсыВалюты.КурсЗнаменатель, 0) > 0
	|				И ЕСТЬNULL(КурсыВалюты.КурсЧислитель, 0) > 0
	|					ТОГДА КурсыВалютыЦены.КурсЧислитель * КурсыВалюты.КурсЗнаменатель / (КурсыВалюты.КурсЧислитель *
	|						КурсыВалютыЦены.КурсЗнаменатель)
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Цена
	|ИЗ
	|	ВтИсточникДанных КАК ВтИсточникДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),) КАК
	|			ЦеныНоменклатурыПоставщиковСрезПоследних
	|		ПО ВтИсточникДанных.Номенклатура = ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура
	|		И ВтИсточникДанных.Характеристика = ЦеныНоменклатурыПоставщиковСрезПоследних.Характеристика
	|		И ВтИсточникДанных.ВидЦеныПоставщика = ЦеныНоменклатурыПоставщиковСрезПоследних.ВидЦеныПоставщика
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК
	|			КурсыВалютыЦены
	|		ПО (ЦеныНоменклатурыПоставщиковСрезПоследних.Валюта = КурсыВалютыЦены.Валюта)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта
	|		И БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалюты
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНДСНоменклатуры.СрезПоследних(&Дата, Страна = &СтранаРегистрации
	|		ИЛИ Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка)) КАК СтавкиНДСНоменклатуры
	|		ПО ВтИсточникДанных.Номенклатура = СтавкиНДСНоменклатуры.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСтавкиНДС.СрезПоследних(&Дата, Страна = &СтранаРегистрации) КАК
	|			ОсновныеСтавкиНДС
	|		ПО (ИСТИНА)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ВтИсточникДанных.Упаковка",
			"ВтИсточникДанных.Номенклатура"));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыПоставщиковСрезПоследних.Упаковка",
			"ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура"));
	
	Результат.Добавить(ТекстЗапроса, "ЗаполнитьЦенуЗакупки");
	
	Возврат Результат;
	
КонецФункции

// Получить тексты запросов получения условий закупок.
//
// Параметры:
// 	ПараметрыДействия - Структура - параметры получения цен закупки.
//
// Возвращаемое значение:
// 	СписокЗначений Из Строка - тексты запросов получения цен для вставки.
//
Функция ТекстыЗапросовЗаполненияУсловийЗакупокПакетнаяОбработка(ПараметрыДействия) Экспорт
	
	Результат = Новый СписокЗначений();
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ВтИсточникДанных.ИдентификаторСтрокиВТ КАК ИдентификаторСтрокиВТ,
	|	ЕСТЬNULL(ТаблицаСоглашений.ВидЦеныПоставщика, ЗНАЧЕНИЕ(Справочник.СоглашенияСПоставщиками.ПустаяСсылка)) КАК
	|		ВидЦеныПоставщика,
	|	ВЫБОР
	|		КОГДА &ВернутьМногооборотнуюТару = ИСТИНА
	|		И ВтИсточникДанных.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|			ТОГДА ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
	|		КОГДА &НалогообложениеНДС = ЗНАЧЕНИЕ(Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС)
	|			ТОГДА ЕСТЬNULL(СтавкиНДСНоменклатуры.СтавкаНДС, ЕСТЬNULL(ОсновныеСтавкиНДС.СтавкаНДС,
	|				ЗНАЧЕНИЕ(Справочник.СтавкиНДС.ПустаяСсылка)))
	|		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.СтавкиНДС.БезНДС)
	|	КОНЕЦ КАК СтавкаНДС,
	|	ВЫБОР
	|		КОГДА ВтИсточникДанных.Упаковка <> ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
	|			ТОГДА &ТекстЗапросаКоэффициентУпаковки1
	|		ИНАЧЕ 1
	|	КОНЕЦ * ЕСТЬNULL(ЦеныНоменклатурыПоставщиковСрезПоследних.Цена, 0) / ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки2, 1) *
	|		ВЫБОР
	|		КОГДА &Валюта <> ЦеныНоменклатурыПоставщиковСрезПоследних.Валюта
	|			ТОГДА ВЫБОР
	|				КОГДА ЕСТЬNULL(КурсыВалютыЦены.КурсЗнаменатель, 0) > 0
	|				И ЕСТЬNULL(КурсыВалютыЦены.КурсЧислитель, 0) > 0
	|				И ЕСТЬNULL(КурсыВалюты.КурсЗнаменатель, 0) > 0
	|				И ЕСТЬNULL(КурсыВалюты.КурсЧислитель, 0) > 0
	|					ТОГДА КурсыВалютыЦены.КурсЧислитель * КурсыВалюты.КурсЗнаменатель / (КурсыВалюты.КурсЧислитель *
	|						КурсыВалютыЦены.КурсЗнаменатель)
	|				ИНАЧЕ 0
	|			КОНЕЦ
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК Цена
	|ИЗ
	|	ВтИсточникДанных КАК ВтИсточникДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СоглашенияСПоставщиками КАК ТаблицаСоглашений
	|		ПО (ТаблицаСоглашений.Ссылка = &Соглашение)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатурыПоставщиков.СрезПоследних(КОНЕЦПЕРИОДА(&Дата, ДЕНЬ),) КАК
	|			ЦеныНоменклатурыПоставщиковСрезПоследних
	|		ПО ВтИсточникДанных.Номенклатура = ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура
	|		И ВтИсточникДанных.Характеристика = ЦеныНоменклатурыПоставщиковСрезПоследних.Характеристика
	|		И (ТаблицаСоглашений.ВидЦеныПоставщика = ЦеныНоменклатурыПоставщиковСрезПоследних.ВидЦеныПоставщика)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, БазоваяВалюта = &БазоваяВалюта) КАК
	|			КурсыВалютыЦены
	|		ПО (ЦеныНоменклатурыПоставщиковСрезПоследних.Валюта = КурсыВалютыЦены.Валюта)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта
	|		И БазоваяВалюта = &БазоваяВалюта) КАК КурсыВалюты
	|		ПО (ИСТИНА)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СтавкиНДСНоменклатуры.СрезПоследних(&Дата, Страна = &СтранаРегистрации
	|		ИЛИ Страна = ЗНАЧЕНИЕ(Справочник.СтраныМира.ПустаяСсылка)) КАК СтавкиНДСНоменклатуры
	|		ПО ВтИсточникДанных.Номенклатура = СтавкиНДСНоменклатуры.Номенклатура
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеСтавкиНДС.СрезПоследних(&Дата, Страна = &СтранаРегистрации) КАК
	|			ОсновныеСтавкиНДС
	|		ПО (ИСТИНА)";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ВтИсточникДанных.Упаковка",
			"ВтИсточникДанных.Номенклатура"));
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"ЦеныНоменклатурыПоставщиковСрезПоследних.Упаковка",
			"ЦеныНоменклатурыПоставщиковСрезПоследних.Номенклатура"));
	
	Результат.Добавить(ТекстЗапроса, "ЗаполнитьУсловияЗакупок");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецОбласти
