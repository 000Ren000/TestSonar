﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.Владелец) Тогда
		ВызватьИсключение НСтр("ru='Предусмотрено открытие обработки только из документов.'");
	КонецЕсли;
	
	Объект.Владелец       = Параметры.Владелец;
	Объект.Организация    = Параметры.Организация;
	Объект.Склад          = Параметры.Склад;
	Объект.Договор        = Параметры.Договор;
	Объект.ТипЗапасов     = Параметры.ТипЗапасов;
	ХозяйственнаяОперация = Параметры.ХозяйственнаяОперация;
	Заказ                 = Параметры.Заказ;
	
	Если ЗначениеЗаполнено(Параметры.Заголовок) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок     = Параметры.Заголовок;
	КонецЕсли;
	
	ЗаполнитьСписокВыбораРежимОстатков();
	ЗаполнитьСкладыНастроитьВидимость();
	ЗаполнитьТаблицуТовары();
	
	СформироватьИнформационнуюНадписьОтборы();
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьЗаголовокНомерГТД(Элементы, "ТоварыНомерГТД");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И Модифицированность Тогда
		
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные были изменены. Все изменения будут потеряны.'");
		
		Возврат;
		
	КонецЕсли;
	
	Если ПеренестиВДокумент
		Или ВыполняетсяЗакрытие
		Или Не ТоварыПодобраны Тогда
		
		Возврат;
		
	Иначе
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Подобранные товары не перенесены в документ. Перенести?'");
		
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		Если РазрешитьПереносРезультатовВДокумент() Тогда
			ПеренестиВДокумент  = Истина;
			ВыполняетсяЗакрытие = Истина;
			
			Закрыть();
		КонецЕсли;
		
		Возврат;
		
	КонецЕсли;
	
	ВыполняетсяЗакрытие = Истина;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СохранитьНастройкиФормыНаСервере();
	
	Если ПеренестиВДокумент Тогда
		Структура = Новый Структура("АдресТоваровВХранилище", АдресТоваровВХранилище());
		ОповеститьОВыборе(Структура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимОстатковПриИзменении(Элемент)
	
	РежимОстатковПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыПометкаПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьКоличествоВСтроке(Объект.Товары, ТекущиеДанные, ТоварыПодобраны);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПодобраноПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ТекущиеДанные.Пометка = ТекущиеДанные.КоличествоПодобрано > 0;
	
	РассчитатьКоличествоВСтроке(Объект.Товары, ТекущиеДанные, ТоварыПодобраны);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	ОчиститьСообщения();
	
	Если РазрешитьПереносРезультатовВДокумент() Тогда
		ПеренестиВДокумент = Истина;
		
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ОтметитьВсеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометку(Команда)
	
	СнятьПометкуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Установка условного оформления для элемента 'КоличествоПодобрано' табличной части 'Товары'.
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКоличествоПодобрано.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Товары.Пометка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораРежимОстатков()
	
	РежимыОстатков = Новый СписокЗначений;
	
	Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ОтгрузкаПринятыхСПравомПродажиТоваровСХранения Тогда
		
		РежимыОстатков.Добавить("ВсеПринятые", НСтр("ru = 'Все принятые'"));
		
	ИначеЕсли ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеПринятыхТоваровЗаСчетПоклажедателя
		Или ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.СписаниеПринятыхТоваровНаРасходы Тогда
		
		РежимыОстатков.Добавить("КСписанию", НСтр("ru = 'К списанию'"));
	
		
	Иначе
		
		РежимыОстатков.Добавить("ВсеПринятые", НСтр("ru = 'Все принятые'"));
		РежимыОстатков.Добавить("Выбывшие", НСтр("ru = 'Выбывшие'"));
		
	КонецЕсли;
	
	Элементы.РежимОстатков.СписокВыбора.Очистить();
	
	Для Каждого Режим Из РежимыОстатков Цикл
		Элементы.РежимОстатков.СписокВыбора.Добавить(Режим.Значение, Режим.Представление);
	КонецЦикла;
	
	Если РежимыОстатков.Количество() = 1 Тогда
		Элементы.РежимОстатков.Видимость = Ложь;
		Объект.РежимОстатков = РежимыОстатков.Получить(0).Значение;
	Иначе
		ЗагрузитьНастройкиФормыНаСервере(РежимыОстатков);
	КонецЕсли;
	
	НастроитьФорму();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиФормыНаСервере(РежимыОстатков)
	
	КлючОбъекта             = "Обработка_ПодборТоваровПринятыхНаОтветственноеХранилище";
	НастройкаРежимаОстатков = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, "");
	
	Если НастройкаРежимаОстатков = Неопределено Тогда
		Объект.РежимОстатков = РежимыОстатков.Получить(0).Значение;
	Иначе
		
		ЗначениеРежима = РежимыОстатков.НайтиПоЗначению(НастройкаРежимаОстатков);
		
		Если ЗначениеРежима <> Неопределено Тогда
			Объект.РежимОстатков = ЗначениеРежима.Значение;
		Иначе
			Объект.РежимОстатков = РежимыОстатков.Получить(0).Значение;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФорму()
	
	ВидимостьКолонкиМестоХранения = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов")
									Или ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство")
									Или ПолучитьФункциональнуюОпцию("ИспользоватьПередачуНаОтветственноеХранениеСПравомПродажи");
	
	ЗаголовокКолонкиМестоХранения = НСтр("ru = 'Место хранения'");
	ЗаголовокКолонкиОстаток       = НСтр("ru = 'Остаток'");
	
	Если Объект.РежимОстатков = "ВсеПринятые" Тогда
		
		ЗаголовокКолонкиОстаток       = НСтр("ru = 'Всего принято'");
		
		Если ХозяйственнаяОперация = Перечисления.ХозяйственныеОперации.ВыкупПринятыхНаХранениеТоваров Тогда
			ВидимостьКолонкиМестоХранения = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоСкладов");
		Иначе
			ВидимостьКолонкиМестоХранения = Склады.Количество() > 1;
			ЗаголовокКолонкиМестоХранения = НСтр("ru = 'Склад'");
		КонецЕсли;
		
	ИначеЕсли Объект.РежимОстатков = "Выбывшие" Тогда
		ЗаголовокКолонкиОстаток = НСтр("ru = 'Выбыло'");
	ИначеЕсли Объект.РежимОстатков = "КСписанию" Тогда
		ЗаголовокКолонкиОстаток = НСтр("ru = 'К списанию'");
	КонецЕсли;
	
	Элементы.ТоварыГруппаМестоХранения.Видимость = ВидимостьКолонкиМестоХранения;
	
	Элементы.ТоварыМестоХранения.Заголовок     = ЗаголовокКолонкиМестоХранения;
	Элементы.ТоварыКоличествоОстаток.Заголовок = ЗаголовокКолонкиОстаток;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСкладыНастроитьВидимость()
	
	Если ТипЗнч(Объект.Склад) = Тип("СправочникСсылка.Склады")
		И Справочники.Склады.ЭтоГруппа(Объект.Склад) Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Склады.Ссылка КАК Склад
		|ИЗ
		|	Справочник.Склады КАК Склады
		|ГДЕ
		|	Склады.Ссылка В ИЕРАРХИИ(&Склад)
		|	И НЕ Склады.ЭтоГруппа
		|	И НЕ Склады.ПометкаУдаления";
		
		Запрос.УстановитьПараметр("Склад", Объект.Склад);
		
		УстановитьПривилегированныйРежим(Истина);
		Выборка = Запрос.Выполнить().Выбрать();
		УстановитьПривилегированныйРежим(Ложь);
		
		Пока Выборка.Следующий() Цикл
			Склады.Добавить(Выборка.Склад);
		КонецЦикла;
		
	ИначеЕсли ЗначениеЗаполнено(Объект.Склад) Тогда
		Склады.Добавить(Объект.Склад);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТовары(КешироватьДанные = Истина)
	
	ОбновитьПодобранныеТовары(КешироватьДанные);
	
	Если Объект.РежимОстатков = "ВсеПринятые" Тогда
		
		// Вариант подбора товаров в документы "Выкуп товаров принятых на хранение", "Отгрузка товаров с хранения".
		Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыОрганизаций) Тогда
			
			Объект.Товары.Очистить();
			Возврат;
			
		Иначе
			
			ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ВидыЗапасов.Ссылка КАК ВидЗапасов
			|ПОМЕСТИТЬ ТаблицаЗапасов
			|ИЗ
			|	Справочник.ВидыЗапасов КАК ВидыЗапасов
			|ГДЕ
			|	ВидыЗапасов.ВладелецТовара = &Партнер
			|	И ВидыЗапасов.Организация  = &Организация
			|	И ВидыЗапасов.Договор      = &Договор
			|	И (&ПоВсемТипам
			|		ИЛИ ВидыЗапасов.ТипЗапасов В (&ТипыЗапасов))
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТоварыПринятые.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
			|	ТоварыПринятые.Организация                КАК Организация,
			|	ТоварыПринятые.ВидЗапасов                 КАК ВидЗапасов,
			|	ТоварыПринятые.НомерГТД                   КАК НомерГТД,
			|	ТоварыПринятые.КоличествоОстаток          КАК КоличествоОстаток
			|
			|ПОМЕСТИТЬ ТаблицаПринятыхТоваров
			|ИЗ
			|	РегистрНакопления.ТоварыОрганизаций.Остатки(,
			|			Организация = &Организация
			|				И ВидЗапасов В
			|					(ВЫБРАТЬ
			|						ТаблицаЗапасов.ВидЗапасов
			|					ИЗ
			|						ТаблицаЗапасов КАК ТаблицаЗапасов)) КАК ТоварыПринятые
			|
			|ГДЕ
			|	ТоварыПринятые.КоличествоОстаток > 0
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.МестоХранения, НЕОПРЕДЕЛЕНО) КАК МестоХранения,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика,
			|	ВЫБОР
			|		КОГДА Товары.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|			ТОГДА ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|		ИНАЧЕ ЕСТЬNULL(АналитикиУчетаНоменклатуры.Назначение, ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка))
			|	КОНЕЦ                                     КАК Назначение,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК Серия,
			|	ТоварыПринятые.НомерГТД                   КАК НомерГТД,
			|	СУММА(ТоварыПринятые.КоличествоОстаток)   КАК КоличествоОсталосьПодобрать,
			|	СУММА(ТоварыПринятые.КоличествоОстаток)   КАК КоличествоОстаток
			|ИЗ
			|	ТаблицаПринятыхТоваров КАК ТоварыПринятые
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикиУчетаНоменклатуры
			|		ПО ТоварыПринятые.АналитикаУчетаНоменклатуры = АналитикиУчетаНоменклатуры.Ссылка
			|
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Товары
			|		ПО АналитикиУчетаНоменклатуры.Номенклатура = Товары.Ссылка
			|ГДЕ
			|	АналитикиУчетаНоменклатуры.ТипМестаХранения <> ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
			|	И (АналитикиУчетаНоменклатуры.МестоХранения В(&Склады)
			|		ИЛИ &ПоВсемСкладам)
			|	И (&ПоВсемЗаказам ИЛИ АналитикиУчетаНоменклатуры.Назначение.Заказ В (&МассивЗаказов))
			|
			|СГРУППИРОВАТЬ ПО
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.МестоХранения, НЕОПРЕДЕЛЕНО),
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
			|	ВЫБОР
			|		КОГДА Товары.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|			ТОГДА ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|		ИНАЧЕ ЕСТЬNULL(АналитикиУчетаНоменклатуры.Назначение, ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка))
			|	КОНЕЦ,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)),
			|	ТоварыПринятые.НомерГТД
			|
			|УПОРЯДОЧИТЬ ПО
			|	МестоХранения,
			|	Номенклатура,
			|	Характеристика,
			|	Назначение,
			|	Серия,
			|	НомерГТД";
			
		КонецЕсли;
		
	ИначеЕсли Объект.РежимОстатков = "Выбывшие" Тогда
		
		// Вариант подбора товаров в документ "Выкуп товаров принятых на хранение".
		Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.РезервыТоваровОрганизаций) Тогда
			
			Объект.Товары.Очистить();
			Возврат;
			
		Иначе
			
			ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ВидыЗапасов.Ссылка КАК ВидЗапасов
			|
			|ПОМЕСТИТЬ ТаблицаЗапасов
			|ИЗ
			|	Справочник.ВидыЗапасов КАК ВидыЗапасов
			|
			|ГДЕ
			|	ВидыЗапасов.ВладелецТовара = &Партнер
			|	И ВидыЗапасов.Организация  = &Организация
			|	И ВидыЗапасов.Договор      = &Договор
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ТоварыВыбывшие.АналитикаУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры,
			|	ТоварыВыбывшие.Организация                КАК Организация,
			|	ТоварыВыбывшие.ВидЗапасов                 КАК ВидЗапасов,
			|	ТоварыВыбывшие.НомерГТД                   КАК НомерГТД,
			|	-ТоварыВыбывшие.КоличествоОстаток         КАК КоличествоОстаток
			|
			|ПОМЕСТИТЬ ТаблицаВыбывшихТоваров
			|ИЗ
			|	РегистрНакопления.РезервыТоваровОрганизаций.Остатки(,
			|			Организация = &Организация
			|				И ВидЗапасов В
			|					(ВЫБРАТЬ
			|						ТаблицаЗапасов.ВидЗапасов
			|					ИЗ
			|						ТаблицаЗапасов КАК ТаблицаЗапасов)) КАК ТоварыВыбывшие
			|
			|ГДЕ
			|	-ТоварыВыбывшие.КоличествоОстаток > 0
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.МестоХранения, НЕОПРЕДЕЛЕНО) КАК МестоХранения,
			|	ВЫБОР
			|		КОГДА АналитикиУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
			|			ТОГДА ЕСТЬNULL(АналитикиУчетаНоменклатуры.Партнер, ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка))
			|		ИНАЧЕ НЕОПРЕДЕЛЕНО
			|	КОНЕЦ                                     КАК Хранитель,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)) КАК Номенклатура,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)) КАК Характеристика,
			|	ВЫБОР
			|		КОГДА Товары.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|			ТОГДА ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|		ИНАЧЕ ЕСТЬNULL(АналитикиУчетаНоменклатуры.Назначение, ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка))
			|	КОНЕЦ                                     КАК Назначение,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)) КАК Серия,
			|	ТоварыВыбывшие.НомерГТД                   КАК НомерГТД,
			|	СУММА(ТоварыВыбывшие.КоличествоОстаток)   КАК КоличествоОсталосьПодобрать,
			|	СУММА(ТоварыВыбывшие.КоличествоОстаток)   КАК КоличествоОстаток
			|ИЗ
			|	ТаблицаВыбывшихТоваров КАК ТоварыВыбывшие
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикиУчетаНоменклатуры
			|		ПО ТоварыВыбывшие.АналитикаУчетаНоменклатуры = АналитикиУчетаНоменклатуры.Ссылка
			|		
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Товары
			|		ПО АналитикиУчетаНоменклатуры.Номенклатура = Товары.Ссылка
			|
			|СГРУППИРОВАТЬ ПО
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.МестоХранения, НЕОПРЕДЕЛЕНО),
			|	ВЫБОР
			|		КОГДА АналитикиУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
			|			ТОГДА ЕСТЬNULL(АналитикиУчетаНоменклатуры.Партнер, ЗНАЧЕНИЕ(Справочник.Партнеры.ПустаяСсылка))
			|		ИНАЧЕ НЕОПРЕДЕЛЕНО
			|	КОНЕЦ,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Номенклатура, ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)),
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Характеристика, ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)),
			|	ВЫБОР
			|		КОГДА Товары.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|			ТОГДА ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|		ИНАЧЕ ЕСТЬNULL(АналитикиУчетаНоменклатуры.Назначение, ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка))
			|	КОНЕЦ,
			|	ЕСТЬNULL(АналитикиУчетаНоменклатуры.Серия, ЗНАЧЕНИЕ(Справочник.СерииНоменклатуры.ПустаяСсылка)),
			|	ТоварыВыбывшие.НомерГТД
			|
			|УПОРЯДОЧИТЬ ПО
			|	МестоХранения,
			|	Номенклатура,
			|	Характеристика,
			|	Назначение,
			|	Серия,
			|	НомерГТД";
			
		КонецЕсли;
		
	ИначеЕсли Объект.РежимОстатков = "КСписанию" Тогда
		
		// Вариант подбора товаров в документ "ОтчетОСписанииТоваровСХранения".
		Если Не ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ТоварыОрганизаций) Тогда
			
			Объект.Товары.Очистить();
			Возврат;
			
		Иначе
			
			ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ВидыЗапасов.Ссылка КАК ВидЗапасов
			|ПОМЕСТИТЬ ТаблицаЗапасов
			|ИЗ
			|	Справочник.ВидыЗапасов КАК ВидыЗапасов
			|
			|ГДЕ
			|	ВидыЗапасов.ВладелецТовара = &Партнер
			|	И ВидыЗапасов.Организация  = &Организация
			|	И ВидыЗапасов.Договор      = &Договор
			|	И (&ПоВсемТипам
			|		ИЛИ ВидыЗапасов.ТипЗапасов В (&ТипыЗапасов))
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	АналитикаУчетаНоменклатуры.МестоХранения  КАК МестоХранения,
			|	ВЫБОР
			|		КОГДА АналитикиУчетаНоменклатуры.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
			|			ТОГДА АналитикиУчетаНоменклатуры.Партнер
			|		ИНАЧЕ НЕОПРЕДЕЛЕНО
			|	КОНЕЦ                                     КАК Хранитель,
			|	АналитикаУчетаНоменклатуры.Номенклатура   КАК Номенклатура,
			|	АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
			|	ВЫБОР
			|		КОГДА АналитикаУчетаНоменклатуры.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
			|			ТОГДА ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|		ИНАЧЕ АналитикаУчетаНоменклатуры.Назначение
			|	КОНЕЦ                                     КАК Назначение,
			|	АналитикаУчетаНоменклатуры.Серия          КАК Серия,
			|	НомерГТД                                  КАК НомерГТД,
			|	КОформлениюСписанияОстаток                КАК КоличествоОстаток,
			|	КОформлениюСписанияОстаток                КАК КоличествоОсталосьПодобрать
			|
			|ИЗ
			|	РегистрНакопления.ТоварыОрганизаций.Остатки(,
			|				Организация = &Организация
			|				И ВидЗапасов В
			|					(ВЫБРАТЬ
			|						ТаблицаЗапасов.ВидЗапасов
			|					ИЗ
			|						ТаблицаЗапасов КАК ТаблицаЗапасов)
			|	) КАК ТоварыВыбывшие
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикиУчетаНоменклатуры
			|		ПО ТоварыВыбывшие.АналитикаУчетаНоменклатуры = АналитикиУчетаНоменклатуры.Ссылка
			|
			|ГДЕ
			|	ТоварыВыбывшие.КОформлениюСписанияОстаток > 0
			|
			|УПОРЯДОЧИТЬ ПО
			|	МестоХранения,
			|	Номенклатура,
			|	Характеристика,
			|	Назначение,
			|	Серия,
			|	НомерГТД";
			
		КонецЕсли;
		
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Если Не ЗначениеЗаполнено(Объект.ТипЗапасов) Тогда
		ТипыЗапасов = Неопределено;
	ИначеЕсли ТипЗнч(Объект.ТипЗапасов) = Тип("СписокЗначений") Тогда
		ТипыЗапасов = Объект.ТипЗапасов;
	Иначе
		ТипыЗапасов = Новый СписокЗначений;
		ТипыЗапасов.Добавить(Объект.ТипЗапасов);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Заказ) Тогда
		МассивЗаказов = Неопределено;
	Иначе
		МассивЗаказов = Новый Массив;
		МассивЗаказов.Добавить(Заказ);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Партнер",       Объект.Владелец);
	Запрос.УстановитьПараметр("Организация",   Объект.Организация);
	Запрос.УстановитьПараметр("Склады",        Склады);
	Запрос.УстановитьПараметр("ПоВсемСкладам", Склады.Количество() = 0);
	Запрос.УстановитьПараметр("Договор",       Объект.Договор);
	Запрос.УстановитьПараметр("ТипыЗапасов",   ТипыЗапасов);
	Запрос.УстановитьПараметр("ПоВсемТипам",   ТипыЗапасов = Неопределено);
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Запрос.УстановитьПараметр("ПоВсемЗаказам",  МассивЗаказов = Неопределено);
	
	Объект.Товары.Загрузить(Запрос.Выполнить().Выгрузить());
	
	ЗаполнитьТоварыПодобраннымиТоварами();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПодобранныеТовары(КешироватьДанные)
	
	ХозОперации = Новый Массив;
	ХозОперации.Добавить(Перечисления.ХозяйственныеОперации.ВыкупПринятыхНаХранениеТоваров);
	
	Если ХозОперации.Найти(ХозяйственнаяОперация) = Неопределено
		Или Не КешироватьДанные Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Отбор = Новый Структура("Номенклатура, Характеристика, Назначение, Серия, НомерГТД, МестоХранения");
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		
		Если СтрокаТоваров.Пометка
			Или СтрокаТоваров.КоличествоПодобрано > 0 Тогда
			
			ЗаполнитьЗначенияСвойств(Отбор, СтрокаТоваров);
			
			СтрокиПодобранныхТоваров = ПодобранныеТовары.НайтиСтроки(Отбор);
			
			Если СтрокиПодобранныхТоваров.Количество() = 0 Тогда
				НоваяСтрока = ПодобранныеТовары.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТоваров);
			Иначе
				ЗаполнитьЗначенияСвойств(СтрокиПодобранныхТоваров[0], СтрокаТоваров);
			КонецЕсли;
			
		ИначеЕсли Не СтрокаТоваров.Пометка
			И СтрокаТоваров.КоличествоПодобрано = 0 Тогда
			
			ЗаполнитьЗначенияСвойств(Отбор, СтрокаТоваров);
			
			СтрокиПодобранныхТоваров = ПодобранныеТовары.НайтиСтроки(Отбор);
			
			Если СтрокиПодобранныхТоваров.Количество() > 0 Тогда
				ПодобранныеТовары.Удалить(СтрокиПодобранныхТоваров[0]);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТоварыПодобраннымиТоварами()
	
	ХозОперации = Новый Массив;
	ХозОперации.Добавить(Перечисления.ХозяйственныеОперации.ВыкупПринятыхНаХранениеТоваров);
	
	Если ХозОперации.Найти(ХозяйственнаяОперация) = Неопределено
		Или Объект.Товары.Количество() = 0 Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Отбор = Новый Структура("Номенклатура, Характеристика, Назначение, Серия, НомерГТД, МестоХранения");
	
	Для Каждого СтрокаПодобранныхТоваров Из ПодобранныеТовары Цикл
		
		ЗаполнитьЗначенияСвойств(Отбор, СтрокаПодобранныхТоваров);
		
		СтрокиТоваров = Объект.Товары.НайтиСтроки(Отбор);
		
		Если СтрокиТоваров.Количество() > 0 Тогда
			ИзменяемаяСтрока = СтрокиТоваров[0];
			ЗаполнитьЗначенияСвойств(ИзменяемаяСтрока, СтрокаПодобранныхТоваров);
			
			Если ИзменяемаяСтрока.Пометка Тогда
				
				ИзменяемаяСтрока.КоличествоОсталосьПодобрать = ИзменяемаяСтрока.КоличествоОстаток
																- ИзменяемаяСтрока.КоличествоПодобрано;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормыНаСервере()
	
	КлючОбъекта = "Обработка_ПодборТоваровПринятыхНаОтветственноеХранилище";
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(КлючОбъекта, "", Объект.РежимОстатков);
	
КонецПроцедуры

&НаСервере
Функция АдресТоваровВХранилище()
	
	Отбор = Новый Структура("Пометка", Истина);
	ОтобранныеТовары      = Объект.Товары.Выгрузить(Отбор);
	
	Возврат ПоместитьВоВременноеХранилище(ОтобранныеТовары, УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура РежимОстатковПриИзмененииНаСервере()
	
	ЗаполнитьТаблицуТовары();
	НастроитьФорму();
	
КонецПроцедуры

&НаСервере
Функция РазрешитьПереносРезультатовВДокумент()
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

&НаСервере
Процедура ОтметитьВсеНаСервере()
	
	Модифицированность = Истина;
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		СтрокаТоваров.КоличествоПодобрано = СтрокаТоваров.КоличествоОстаток;
		СтрокаТоваров.Пометка = Истина;
		
		РассчитатьКоличествоВСтроке(Объект.Товары, СтрокаТоваров, ТоварыПодобраны);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура СнятьПометкуНаСервере()
	
	Для Каждого СтрокаТоваров Из Объект.Товары Цикл
		СтрокаТоваров.Пометка = Ложь;
		
		РассчитатьКоличествоВСтроке(Объект.Товары, СтрокаТоваров, ТоварыПодобраны);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	ПодобранныеТовары.Очистить();
	ЗаполнитьТаблицуТовары(Ложь);
	
КонецПроцедуры

&НаСервере
Процедура СформироватьИнформационнуюНадписьОтборы()
	
	Если Не ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		ИнформационнаяНадписьОтборы = НСтр("ru='Отбор по: %Организация%, %Партнер%, %Договор%, %Склад%'");
	Иначе
		ИнформационнаяНадписьОтборы = НСтр("ru='Отбор по: %Договор%, %Склад%'");
	КонецЕсли;
	
	Если Склады.Количество() > 1 Тогда
		НадписьСклад = НСтр("ru='группе складов: ""%Склад%""'");
		НадписьСклад = СтрЗаменить(НадписьСклад, "%Склад%", Объект.Склад);
	Иначе
		НадписьСклад = "";
	КонецЕсли;
	
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы, "%Организация%", Объект.Организация);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы, "%Партнер%",     Объект.Владелец);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы, "%Договор%",     Объект.Договор);
	ИнформационнаяНадписьОтборы = СтрЗаменить(ИнформационнаяНадписьОтборы, "%Склад%",       НадписьСклад);
	
	Если Прав(ИнформационнаяНадписьОтборы, 2) = ", " Тогда
		ИнформационнаяНадписьОтборы = Лев(ИнформационнаяНадписьОтборы, СтрДлина(ИнформационнаяНадписьОтборы) - 2);
	КонецЕсли;
	
	ИнформационнаяНадписьОтборы = ИнформационнаяНадписьОтборы + ".";
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура РассчитатьКоличествоВСтроке(Товары, ТекущиеДанные, ТоварыПодобраны)
	
	ТекущиеДанные.КоличествоОсталосьПодобрать = ТекущиеДанные.КоличествоОстаток -ТекущиеДанные.КоличествоПодобрано;
	
	Отбор = Новый Структура("Пометка", Истина);
	ПомеченныеСтроки = Товары.НайтиСтроки(Отбор);
	
	ТоварыПодобраны = ПомеченныеСтроки.Количество() > 0;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти
