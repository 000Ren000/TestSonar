﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Организация = Параметры.Организация;
	ОрганизацияПолучатель = Параметры.ОрганизацияПолучатель;
	Склад = Параметры.Склад;
	АдресВХранилище = Параметры.АдресВХранилище;
	ОтрицательныеОстатки = Параметры.ОтрицательныеОстатки;
	Дата = Параметры.Дата;
	
	Если Параметры.Свойство("НалогообложениеНДС") Тогда
		Ограничения = УчетНДСУП.ОграничениеТоваровПоНалогообложению(Параметры.НалогообложениеНДС);
		Для Каждого Ограничение Из Ограничения Цикл
			Если Ограничение.Реквизит = "ПодакцизныйТовар" Тогда
				СкрыватьПодакцизныеТовары = Истина;
			КонецЕсли;
			Если Ограничение.Реквизит = "ОблагаетсяНДСУПокупателя" Тогда
				ОблагаетсяНДСУПокупателя = Ограничение.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЭтоКомиссия = ?(Параметры.Свойство("ЭтоКомиссия") <> Ложь, Параметры.ЭтоКомиссия, Ложь);
	ЭтоПродажа = ?(Параметры.Свойство("ЭтоПродажа") <> Ложь, Параметры.ЭтоПродажа, Ложь);
	ЭтоВозврат = ?(Параметры.Свойство("ЭтоВозврат") <> Ложь, Параметры.ЭтоВозврат, Ложь);
	
	Элементы.СкрыватьПодакцизныеТовары.Видимость = СкрыватьПодакцизныеТовары;
	Элементы.ТаблицаТоваровСерия.Видимость = Параметры.ИспользоватьСерииНоменклатуры;
	
	ЗаполнитьТаблицуТоваров();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура СкрыватьПодакцизныеТоварыПриИзменении(Элемент)
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТоваровКоличествоПриИзменении(Элемент)
	
	СтрокаТаблицы = Элементы.ТаблицаТоваров.ТекущиеДанные;
	СтрокаТаблицы.Выбран = (СтрокаТаблицы.Количество <> 0);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокументВыполнить()

	ПоместитьТоварыВХранилище();
	Закрыть(КодВозвратаДиалога.OK);
	
	ОповеститьОВыборе(АдресВХранилище);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		Если ОтрицательныеОстатки И СтрокаТаблицы.КоличествоОстатокПолучателя < 0
		 ИЛИ Не ОтрицательныеОстатки И СтрокаТаблицы.КоличествоОстатокОтправителя > 0 Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьСтрокиВыполнить()

	Для Каждого СтрокаТаблицы Из ТаблицаТоваров Цикл
		СтрокаТаблицы.Выбран = Ложь
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключитьВыделенныеСтроки(Команда)
	
	МассивСтрок = Элементы.ТаблицаТоваров.ВыделенныеСтроки;
	Для Каждого НомерСтроки Из МассивСтрок Цикл
		СтрокаТаблицы = ТаблицаТоваров.НайтиПоИдентификатору(НомерСтроки);
		Если СтрокаТаблицы <> Неопределено Тогда
			СтрокаТаблицы.Выбран = Ложь;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ЗаполнитьТаблицуТоваров();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТаблицаТоваров.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТаблицаТоваров.Выбран");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.RosyBrown);

КонецПроцедуры

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.ОрганизацияПолучатель.Видимость = ОтрицательныеОстатки;
	Элементы.ТаблицаТоваровКоличествоОстатокПолучателя.Видимость = ОтрицательныеОстатки;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ПоместитьТоварыВХранилище() 
	
	Отбор = Новый Структура("Выбран", Истина);
	Товары = ТаблицаТоваров.Выгрузить(Отбор, "Выбран, Номенклатура, Характеристика, Серия, Назначение, КоличествоУпаковок, Количество");
	
	Для Каждого СтрокаТаблицы Из Товары Цикл
		СтрокаТаблицы.КоличествоУпаковок = СтрокаТаблицы.Количество;
	КонецЦикла;
	
	ПоместитьВоВременноеХранилище(Товары, АдресВХранилище);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваров()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	Товары.Номенклатура КАК Номенклатура,
	|	Товары.Характеристика КАК Характеристика,
	|	Товары.Серия КАК Серия,
	|	Товары.Количество КАК Количество,
	|	Товары.Назначение КАК Назначение
	|
	|ПОМЕСТИТЬ Товары
	|ИЗ
	|	&Товары КАК Товары
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.Номенклатура             КАК Номенклатура,
	|	Остатки.Характеристика           КАК Характеристика,
	|	Остатки.Серия                    КАК Серия,
	|	Остатки.Назначение               КАК Назначение,
	|	СУММА(Остатки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ОстаткиОтправителя
	|ИЗ
	|	(ВЫБРАТЬ
	|		Остатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|		Остатки.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|		Остатки.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|		Остатки.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|		СУММА(Остатки.КоличествоОстаток) КАК КоличествоОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций.Остатки(&Граница,
	|			Организация = &ОрганизацияОтправитель
	|			И АналитикаУчетаНоменклатуры.МестоХранения = &Склад
	|			И ВидЗапасов.ТипЗапасов В (&ДоступныеТипыЗапасов)
	|			И (ВидЗапасов.ВладелецТовара = &ВладелецТовара ИЛИ &ПоВсемВладельцам)
	|		) КАК Остатки
	|
	|	ГДЕ
	|		НЕ (Остатки.АналитикаУчетаНоменклатуры.Номенклатура.ПодакцизныйТовар И &СкрыватьПодакцизныеТовары)
	|		
	|	СГРУППИРОВАТЬ ПО
	|		Остатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|		Остатки.АналитикаУчетаНоменклатуры.Характеристика,
	|		Остатки.АналитикаУчетаНоменклатуры.Серия,
	|		Остатки.АналитикаУчетаНоменклатуры.Назначение
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Остатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|		Остатки.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|		Остатки.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|		Остатки.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|		СУММА(Остатки.КоличествоОстаток) КАК КоличествоОстаток
	|	ИЗ
	|		РегистрНакопления.РезервыТоваровОрганизаций.Остатки(&Граница,
	|			Организация = &ОрганизацияОтправитель
	|			И АналитикаУчетаНоменклатуры.МестоХранения = &Склад
	|			И ВидЗапасов.ТипЗапасов В (&ДоступныеТипыЗапасов)
	|			И (ВидЗапасов.ВладелецТовара = &ВладелецТовара ИЛИ &ПоВсемВладельцам)
	|		) КАК Остатки
	|
	|	ГДЕ
	|		НЕ (Остатки.АналитикаУчетаНоменклатуры.Номенклатура.ПодакцизныйТовар И &СкрыватьПодакцизныеТовары)
	|	СГРУППИРОВАТЬ ПО
	|		Остатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|		Остатки.АналитикаУчетаНоменклатуры.Характеристика,
	|		Остатки.АналитикаУчетаНоменклатуры.Серия,
	|		Остатки.АналитикаУчетаНоменклатуры.Назначение
	|
	|	) КАК Остатки
	|
	|	СГРУППИРОВАТЬ ПО
	|		Остатки.Номенклатура,
	|		Остатки.Характеристика,
	|		Остатки.Серия,
	|		Остатки.Назначение
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Остатки.Номенклатура КАК Номенклатура,
	|	Остатки.Характеристика КАК Характеристика,
	|	Остатки.Серия КАК Серия,
	|	Остатки.Назначение КАК Назначение,
	|	СУММА(Остатки.КоличествоОстаток) КАК КоличествоОстаток
	|ПОМЕСТИТЬ ОстаткиПолучателя
	|ИЗ
	|	(ВЫБРАТЬ
	|		Остатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|		Остатки.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|		Остатки.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|		Остатки.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|		СУММА(Остатки.КоличествоОстаток) КАК КоличествоОстаток
	|	ИЗ
	|		РегистрНакопления.ТоварыОрганизаций.Остатки(&Граница,
	|			&ОтрицательныеОстатки
	|			И Организация = &ОрганизацияПолучатель
	|			И АналитикаУчетаНоменклатуры.МестоХранения = &Склад
	|		) КАК Остатки
	|
	|	ГДЕ
	|		Остатки.КоличествоОстаток < 0
	|		И НЕ (Остатки.АналитикаУчетаНоменклатуры.Номенклатура.ПодакцизныйТовар И &СкрыватьПодакцизныеТовары)
	|		И Остатки.АналитикаУчетаНоменклатуры.Номенклатура.ОблагаетсяНДСУПокупателя = &ОблагаетсяНДСУПокупателя
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Остатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|		Остатки.АналитикаУчетаНоменклатуры.Характеристика,
	|		Остатки.АналитикаУчетаНоменклатуры.Серия,
	|		Остатки.АналитикаУчетаНоменклатуры.Назначение
	|
	|	ОБЪЕДИНИТЬ ВСЕ
	|
	|	ВЫБРАТЬ
	|		Остатки.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
	|		Остатки.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
	|		Остатки.АналитикаУчетаНоменклатуры.Серия КАК Серия,
	|		Остатки.АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
	|		СУММА(Остатки.КоличествоОстаток) КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.РезервыТоваровОрганизаций.Остатки(&Граница,
	|		&ОтрицательныеОстатки
	|		И Организация = &ОрганизацияПолучатель
	|		И АналитикаУчетаНоменклатуры.МестоХранения = &Склад
	|	) КАК Остатки
	|
	|	ГДЕ
	|		НЕ (Остатки.АналитикаУчетаНоменклатуры.Номенклатура.ПодакцизныйТовар И &СкрыватьПодакцизныеТовары)
	|		И Остатки.АналитикаУчетаНоменклатуры.Номенклатура.ОблагаетсяНДСУПокупателя = &ОблагаетсяНДСУПокупателя
	|	
	|	СГРУППИРОВАТЬ ПО
	|		Остатки.АналитикаУчетаНоменклатуры.Номенклатура,
	|		Остатки.АналитикаУчетаНоменклатуры.Характеристика,
	|		Остатки.АналитикаУчетаНоменклатуры.Серия,
	|		Остатки.АналитикаУчетаНоменклатуры.Назначение
	|
	|	) КАК Остатки
	|
	|СГРУППИРОВАТЬ ПО
	|	Остатки.Номенклатура,
	|	Остатки.Характеристика,
	|	Остатки.Серия,
	|	Остатки.Назначение
	|
	|ИМЕЮЩИЕ
	|	СУММА(Остатки.КоличествоОстаток) < 0
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК Выбран,
	|	ОстаткиПолучателя.Номенклатура КАК Номенклатура,
	|	ОстаткиПолучателя.Характеристика КАК Характеристика,
	|	ОстаткиПолучателя.Серия КАК Серия,
	|	ОстаткиПолучателя.Назначение КАК Назначение,
	|	СУММА(ОстаткиОтправителя.КоличествоОстаток) КАК КоличествоОстатокОтправителя,
	|	СУММА(ОстаткиПолучателя.КоличествоОстаток) КАК КоличествоОстатокПолучателя,
	|
	|	СУММА(ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ВЫБОР КОГДА (-ОстаткиПолучателя.КоличествоОстаток) < ОстаткиОтправителя.КоличествоОстаток ТОГДА
	|			-ОстаткиПолучателя.КоличествоОстаток
	|		ИНАЧЕ
	|			ОстаткиОтправителя.КоличествоОстаток
	|		КОНЕЦ
	|	ИНАЧЕ
	|		Товары.Количество
	|	КОНЕЦ) КАК Количество
	|ИЗ
	|	ОстаткиПолучателя КАК ОстаткиПолучателя
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Товары КАК Товары
	|	ПО
	|		ОстаткиПолучателя.Номенклатура = Товары.Номенклатура
	|		И ОстаткиПолучателя.Характеристика = Товары.Характеристика
	|		И ОстаткиПолучателя.Серия = Товары.Серия
	|		И ОстаткиПолучателя.Назначение = Товары.Назначение
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ОстаткиОтправителя КАК ОстаткиОтправителя
	|	ПО
	|		ОстаткиПолучателя.Номенклатура = ОстаткиОтправителя.Номенклатура
	|		И ОстаткиПолучателя.Характеристика = ОстаткиОтправителя.Характеристика
	|		И ОстаткиПолучателя.Серия = ОстаткиОтправителя.Серия
	|		И ОстаткиПолучателя.Назначение = ОстаткиОтправителя.Назначение
	|ГДЕ
	|	&ОтрицательныеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ,
	|	ОстаткиПолучателя.Номенклатура,
	|	ОстаткиПолучателя.Характеристика,
	|	ОстаткиПолучателя.Серия,
	|	ОстаткиПолучателя.Назначение
	|
	|ИМЕЮЩИЕ
	|	СУММА(ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ВЫБОР КОГДА (-ОстаткиПолучателя.КоличествоОстаток) < ОстаткиОтправителя.КоличествоОстаток ТОГДА
	|			-ОстаткиПолучателя.КоличествоОстаток
	|		ИНАЧЕ
	|			ОстаткиОтправителя.КоличествоОстаток
	|		КОНЕЦ
	|	ИНАЧЕ
	|		Товары.Количество
	|	КОНЕЦ) <> 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ КАК Выбран,
	|	ОстаткиОтправителя.Номенклатура КАК Номенклатура,
	|	ОстаткиОтправителя.Характеристика КАК Характеристика,
	|	ОстаткиОтправителя.Серия КАК Серия,
	|	ОстаткиОтправителя.Назначение КАК Назначение,
	|	СУММА(ОстаткиОтправителя.КоличествоОстаток) КАК КоличествоОстатокОтправителя,
	|	0 КАК КоличествоОстатокПолучателя,
	|
	|	СУММА(ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ОстаткиОтправителя.КоличествоОстаток
	|	ИНАЧЕ
	|		Товары.Количество
	|	КОНЕЦ) КАК Количество
	|ИЗ
	|	ОстаткиОтправителя КАК ОстаткиОтправителя
	|
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		Товары КАК Товары
	|	ПО
	|		ОстаткиОтправителя.Номенклатура = Товары.Номенклатура
	|		И ОстаткиОтправителя.Характеристика = Товары.Характеристика
	|		И ОстаткиОтправителя.Серия = Товары.Серия
	|		И ОстаткиОтправителя.Назначение = Товары.Назначение
	|ГДЕ
	|	НЕ &ОтрицательныеОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ЛОЖЬ
	|	ИНАЧЕ
	|		ИСТИНА
	|	КОНЕЦ,
	|	ОстаткиОтправителя.Номенклатура,
	|	ОстаткиОтправителя.Характеристика,
	|	ОстаткиОтправителя.Серия,
	|	ОстаткиОтправителя.Назначение
	|
	|ИМЕЮЩИЕ
	|	 СУММА(ВЫБОР КОГДА Товары.Количество ЕСТЬ NULL
	|		ИЛИ Товары.Количество = 0
	|	ТОГДА
	|		ОстаткиОтправителя.КоличествоОстаток
	|	ИНАЧЕ
	|		Товары.Количество
	|	КОНЕЦ) <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Номенклатура,
	|	Характеристика,
	|	Серия,
	|	Назначение
	|");
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("ОрганизацияПолучатель", ОрганизацияПолучатель);
	Запрос.УстановитьПараметр("ОрганизацияОтправитель", Организация);
	Запрос.УстановитьПараметр("Склад", Склад);
	Запрос.УстановитьПараметр("ОтрицательныеОстатки", ОтрицательныеОстатки);
	Запрос.УстановитьПараметр("СкрыватьПодакцизныеТовары", СкрыватьПодакцизныеТовары);
	Запрос.УстановитьПараметр("ОблагаетсяНДСУПокупателя", ОблагаетсяНДСУПокупателя);
	
	ДоступныеТипыЗапасов = Новый Массив();
	ВладелецТовара = Неопределено;
	Если ЭтоКомиссия И ЭтоВозврат Тогда
		ДоступныеТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.КомиссионныйТовар);
		ВладелецТовара = ОрганизацияПолучатель;
	Иначе
		ДоступныеТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.КомиссионныйТовар);
		ДоступныеТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.Товар);
		ДоступныеТипыЗапасов.Добавить(Перечисления.ТипыЗапасов.ТоварНаХраненииСПравомПродажи);
	КонецЕсли;
	Запрос.УстановитьПараметр("ДоступныеТипыЗапасов", ДоступныеТипыЗапасов);
	Запрос.УстановитьПараметр("ВладелецТовара", ВладелецТовара);
	Запрос.УстановитьПараметр("ПоВсемВладельцам", Не ЗначениеЗаполнено(ВладелецТовара));
	
	ДатаЗаполнения = ?(ЗначениеЗаполнено(Дата), КонецДня(Дата), ТекущаяДатаСеанса());
	Граница = Новый Граница(ДатаЗаполнения, ВидГраницы.Включая);
	Запрос.УстановитьПараметр("Граница", Граница);
	
	Если ТаблицаТоваров.Количество() > 0 Тогда
		Товары = ТаблицаТоваров.Выгрузить(, "Выбран, Номенклатура, Характеристика, Серия, Назначение, Количество");
		СтрокиКУдалению = Товары.НайтиСтроки(Новый Структура("Выбран", Ложь));
		Для Каждого СтрокаКУдалению Из СтрокиКУдалению Цикл
			Товары.Удалить(СтрокаКУдалению);
		КонецЦикла;
	Иначе
		Товары = ПолучитьИзВременногоХранилища(АдресВХранилище);
		Товары.Свернуть("Номенклатура, Характеристика, Серия, Назначение", "Количество");
	КонецЕсли;
	Запрос.УстановитьПараметр("Товары", Товары);
	
	ПолучательУказан = ЗначениеЗаполнено(ОрганизацияПолучатель);
	ИспользоватьКомиссию = (ЭтоКомиссия И ПолучательУказан);
	ИспользоватьПродажу = (ЭтоПродажа И ПолучательУказан);
	
	Запрос.УстановитьПараметр("ИспользоватьКомиссию", ИспользоватьКомиссию);
	Запрос.УстановитьПараметр("ИспользоватьПродажу", ИспользоватьПродажу);
	Запрос.УстановитьПараметр("КомиссияПриЗакупках", ИспользоватьКомиссию И ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриЗакупках"));
	Запрос.УстановитьПараметр("ЗапасыПоПоставщикам", ИспользоватьПродажу И ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПоставщикам"));
	
	Результат = Запрос.Выполнить();
	ТаблицаТоваров.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
