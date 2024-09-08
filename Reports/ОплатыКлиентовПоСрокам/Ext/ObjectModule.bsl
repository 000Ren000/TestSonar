﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
	// Сформируем отчет
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	МассивВыбранныхПолей = Новый Массив;
	НайтиВыбранныеПоляРекурсивно(НастройкиОтчета.Выбор.Элементы, МассивВыбранныхПолей);
	ВключатьПланОтгрузок = Ложь;
	ВключатьПланОплат = Ложь;
	Для Каждого ВыбранноеПоле Из МассивВыбранныхПолей Цикл 
		Если Строка(ВыбранноеПоле.Поле) = "КОтгрузке" Тогда
			ВключатьПланОтгрузок = Истина;
		КонецЕсли;
		Если Строка(ВыбранноеПоле.Поле) = "ДолгКлиента"
			Или Строка(ВыбранноеПоле.Поле) = "ДолгКлиентаПросрочено" Тогда
			ВключатьПланОплат = Истина;
		КонецЕсли;
	КонецЦикла;
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОтчета, "ВключатьПланОтгрузок", ВключатьПланОтгрузок);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОтчета, "ВключатьПланОплат", ВключатьПланОплат);
	
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных.Запрос = ТекстЗапроса();
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	// Предупреждение о невыполненном распределении взаиморасчетов.
	ВзаиморасчетыСервер.ВывестиПредупреждениеОбОбновлении(ДокументРезультат);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.ОформитьДиаграммыОтчета(КомпоновщикНастроек, ДокументРезультат);
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	// Установка значений по умолчанию
	УстановитьОбязательныеНастройки(КомпоновщикНастроекФормы, Истина);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	УстановитьКалендарь(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	СегментыСервер.ВключитьОтборПоСегментуПартнеровВСКД(КомпоновщикНастроек);
	УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	УстановитьВариантКлассификацииЗадолженности(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	УстановитьСтроковыеПараметрыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы);
	
КонецПроцедуры

Процедура УстановитьДатуОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрДатаОстатков = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчета");
	ПараметрДатаОстатков.Использование = Истина;
	
	ПараметрДатаОтчетаГраница = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ДатаОтчетаГраница");
	ПараметрДатаОтчетаГраница.Использование = Истина;
	
	Если ТипЗнч(ПараметрДатаОстатков.Значение) = Тип("СтандартнаяДатаНачала") Тогда
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОстатков.Значение.Дата) Тогда
			ПараметрДатаОстатков.Значение.Дата = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(ПараметрДатаОстатков.Значение.Дата), ВидГраницы.Включая);
	Иначе
		Если НЕ ЗначениеЗаполнено(ПараметрДатаОстатков.Значение) Тогда
			ПараметрДатаОстатков.Значение = КонецДня(ТекущаяДатаСеанса());
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
		ПараметрДатаОтчетаГраница.Значение = Новый Граница(КонецДня(ПараметрДатаОстатков.Значение), ВидГраницы.Включая);
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьВариантКлассификацииЗадолженности(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрВариантКлассификацииЗадолженности = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВариантКлассификацииЗадолженности");
	Если НЕ ЗначениеЗаполнено(ПараметрВариантКлассификацииЗадолженности.Значение) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
			|	ВариантыКлассификацииЗадолженности.Ссылка
			|ИЗ
			|	Справочник.ВариантыКлассификацииЗадолженности КАК ВариантыКлассификацииЗадолженности
			|ГДЕ
			|	НЕ ВариантыКлассификацииЗадолженности.ПометкаУдаления";
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ПользовательскиеНастройкиМодифицированы = Истина;
			ПараметрВариантКлассификацииЗадолженности.Значение = Выборка.Ссылка;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровКакКонтрагентов") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "Контрагент");
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьСтроковыеПараметрыОтчета(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	
	ПользовательскиеНастройкиМодифицированы = Истина;
	
	ПараметрСтрокаДолгНеКонтролируется = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "СтрокаДолгНеКонтролируется");
	ПараметрСтрокаДолгНеКонтролируется.Значение = НСтр("ru = 'Не контролируется'");
	
	ПараметрСтрокаДолгНеПросрочен = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "СтрокаДолгНеПросрочен");
	ПараметрСтрокаДолгНеПросрочен.Значение = НСтр("ru = 'Не просрочено'");
	
	ПараметрСтрокаСостояниеВзаиморасчетов = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "СтрокаСостояниеВзаиморасчетов");
	ПараметрСтрокаСостояниеВзаиморасчетов.Значение = НСтр("ru = 'Состояние взаиморасчетов'");
	
КонецПроцедуры

Функция ТекстЗапроса()
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	Сегменты.Партнер КАК Партнер,
	|	ИСТИНА КАК ИспользуетсяОтборПоСегментуПартнеров
	|ПОМЕСТИТЬ ОтборПоСегментуПартнеров
	|ИЗ
	|	РегистрСведений.ПартнерыСегмента КАК Сегменты
	|{ГДЕ
	|	Сегменты.Сегмент.* КАК СегментПартнеров,
	|	Сегменты.Партнер.* КАК Партнер}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партнер,
	|	ИспользуетсяОтборПоСегментуПартнеров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаУчета.Организация КАК Организация,
	|	АналитикаУчета.Партнер КАК Партнер,
	|	АналитикаУчета.Контрагент КАК Контрагент,
	|	АналитикаУчета.Договор КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	АналитикаУчета.КлючАналитики КАК КлючАналитики
	|ПОМЕСТИТЬ ВТ_АналитикаУчетаПоПартнерам
	|ИЗ
	|	РегистрСведений.АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|ГДЕ
	|		АналитикаУчета.Партнер <> ЗНАЧЕНИЕ(Справочник.Партнеры.НашеПредприятие)
	|{ГДЕ
	|		АналитикаУчета.Организация.* КАК Организация,
	|		АналитикаУчета.Партнер.* КАК Партнер,
	|		АналитикаУчета.Контрагент.* КАК Контрагент,
	|		АналитикаУчета.Договор.* КАК Договор,
	|		АналитикаУчета.НаправлениеДеятельности.* КАК НаправлениеДеятельности,
	|		(АналитикаУчета.Партнер В
	|				(ВЫБРАТЬ
	|					ОтборПоСегментуПартнеров.Партнер
	|				ИЗ
	|					ОтборПоСегментуПартнеров
	|				ГДЕ
	|					ОтборПоСегментуПартнеров.ИспользуетсяОтборПоСегментуПартнеров = &ИспользуетсяОтборПоСегментуПартнеров))}
	|ИНДЕКСИРОВАТЬ ПО
	|	КлючАналитики
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Организации.Ссылка КАК Организация,
	|	КурсВалюты.Валюта КАК Валюта,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 0
	|			ТОГДА 1
	|		КОГДА 2
	|			ТОГДА ЕСТЬNULL(КурсВалюты.КурсЧислитель, 1) * ЕСТЬNULL(КурсВалютыУпр.КурсЗнаменатель, 1) / (ЕСТЬNULL(КурсВалюты.КурсЗнаменатель, 1) * ЕСТЬNULL(КурсВалютыУпр.КурсЧислитель, 1))
	|		ИНАЧЕ ЕСТЬNULL(КурсВалюты.КурсЧислитель, 1) / ЕСТЬNULL(КурсВалюты.КурсЗнаменатель, 1)
	|	КОНЕЦ КАК Коэффициент
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних({(&ДатаОтчета)}) КАК КурсВалюты
	|			ПО Организации.ВалютаРегламентированногоУчета = КурсВалюты.БазоваяВалюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ОтносительныеКурсыВалют.СрезПоследних({(&ДатаОтчета)}, Валюта = &ВалютаУправленческогоУчета) КАК КурсВалютыУпр
	|			ПО Организации.ВалютаРегламентированногоУчета = КурсВалютыУпр.БазоваяВалюта
	|{ГДЕ
	|	Организации.Ссылка.* КАК Организация}
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Валюта
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АналитикаУчета.Организация КАК Организация,
	|	АналитикаУчета.Партнер КАК Партнер,
	|	АналитикаУчета.Контрагент КАК Контрагент,
	|	АналитикаУчета.Договор КАК Договор,
	|	АналитикаУчета.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	РасчетыПоСрокам.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 0
	|			ТОГДА РасчетыПоСрокам.Валюта
	|		КОГДА 2
	|			ТОГДА &ВалютаУправленческогоУчета
	|		ИНАЧЕ АналитикаУчета.Организация.ВалютаРегламентированногоУчета
	|	КОНЕЦ КАК Валюта,
	|	РасчетыПоСрокам.РасчетныйДокумент КАК РасчетныйДокумент,
	|	РасчетыПоСрокам.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|	РасчетыПоСрокам.ДатаВозникновения КАК ДатаВозникновения,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 0
	|			ТОГДА РасчетыПоСрокам.ПредоплатаОстаток
	|		КОГДА 2
	|			ТОГДА РасчетыПоСрокам.ПредоплатаУпрОстаток
	|		ИНАЧЕ РасчетыПоСрокам.ПредоплатаРеглОстаток
	|	КОНЕЦ КАК НашДолг,
	|	ВЫБОР
	|		КОГДА РасчетыПоСрокам.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|				И РасчетыПоСрокам.ДатаПлановогоПогашения > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ВЫБОР &ДанныеОтчета
	|					КОГДА 0
	|						ТОГДА РасчетыПоСрокам.ПредоплатаОстаток
	|					КОГДА 2
	|						ТОГДА РасчетыПоСрокам.ПредоплатаУпрОстаток
	|					ИНАЧЕ РасчетыПоСрокам.ПредоплатаРеглОстаток
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НашДолгПросрочено,
	|	ВЫБОР
	|		КОГДА РасчетыПоСрокам.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ВЫБОР &ДанныеОтчета
	|					КОГДА 0
	|						ТОГДА РасчетыПоСрокам.ПредоплатаОстаток
	|					КОГДА 2
	|						ТОГДА РасчетыПоСрокам.ПредоплатаУпрОстаток
	|					ИНАЧЕ РасчетыПоСрокам.ПредоплатаРеглОстаток
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК НашДолгНеКонтролируется,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 0
	|			ТОГДА РасчетыПоСрокам.ДолгОстаток
	|		КОГДА 2
	|			ТОГДА РасчетыПоСрокам.ДолгУпрОстаток
	|		ИНАЧЕ РасчетыПоСрокам.ДолгРеглОстаток
	|	КОНЕЦ КАК ДолгКлиента,
	|	ВЫБОР
	|		КОГДА РасчетыПоСрокам.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|			ТОГДА ВЫБОР &ДанныеОтчета
	|					КОГДА 0
	|						ТОГДА РасчетыПоСрокам.ДолгОстаток
	|					КОГДА 2
	|						ТОГДА РасчетыПоСрокам.ДолгУпрОстаток
	|					ИНАЧЕ РасчетыПоСрокам.ДолгРеглОстаток
	|				КОНЕЦ
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ДолгКлиентаПросрочено,
	|	0 КАК КОтгрузке
	|ПОМЕСТИТЬ ТаблицаЗадолженностей
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПоСрокам.Остатки(&ДатаОтчетаГраница,
	|		АналитикаУчетаПоПартнерам В
	|				(ВЫБРАТЬ
	|					ВТ_АналитикаУчетаПоПартнерам.КлючАналитики
	|				ИЗ
	|					ВТ_АналитикаУчетаПоПартнерам)) КАК РасчетыПоСрокам
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО РасчетыПоСрокам.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|ГДЕ
	|	(&ВключатьЗадолженность = 0
	|			ИЛИ &ВключатьЗадолженность = 1)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаУчета.Организация,
	|	АналитикаУчета.Партнер,
	|	АналитикаУчета.Контрагент,
	|	АналитикаУчета.Договор,
	|	АналитикаУчета.НаправлениеДеятельности,
	|	РасчетыПланОплат.ОбъектРасчетов,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 0
	|			ТОГДА РасчетыПланОплат.Валюта
	|		КОГДА 2
	|			ТОГДА &ВалютаУправленческогоУчета
	|		ИНАЧЕ АналитикаУчета.Организация.ВалютаРегламентированногоУчета
	|	КОНЕЦ,
	|	РасчетыПланОплат.ДокументПлан,
	|	РасчетыПланОплат.ДатаПлановогоПогашения,
	|	РасчетыПланОплат.ДатаВозникновения,
	|	0,
	|	0,
	|	0,
	|	РасчетыПланОплат.КОплатеОстаток * КурсВалюты.Коэффициент,
	|	ВЫБОР
	|		КОГДА РасчетыПланОплат.ДатаПлановогоПогашения < НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|			ТОГДА РасчетыПланОплат.КОплатеОстаток * КурсВалюты.Коэффициент
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	0
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПланОплат.Остатки(&ДатаОтчетаГраница,
	|		АналитикаУчетаПоПартнерам В
	|				(ВЫБРАТЬ
	|					ВТ_АналитикаУчетаПоПартнерам.КлючАналитики
	|				ИЗ
	|					ВТ_АналитикаУчетаПоПартнерам)
	|		И ТИПЗНАЧЕНИЯ(ДокументПлан) В (&ТипыДокументовПлана)) КАК РасчетыПланОплат
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО РасчетыПланОплат.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсВалюты
	|			ПО (КурсВалюты.Валюта = РасчетыПланОплат.Валюта)
	|			И (КурсВалюты.Организация = АналитикаУчета.Организация)
	|ГДЕ
	|	(&ВключатьЗадолженность = 0
	|			ИЛИ &ВключатьЗадолженность = 2)
	|	И &ВключатьПланОплат
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	АналитикаУчета.Организация,
	|	АналитикаУчета.Партнер,
	|	АналитикаУчета.Контрагент,
	|	АналитикаУчета.Договор,
	|	АналитикаУчета.НаправлениеДеятельности,
	|	РасчетыПланОтгрузок.ОбъектРасчетов,
	|	ВЫБОР &ДанныеОтчета
	|		КОГДА 0
	|			ТОГДА РасчетыПланОтгрузок.Валюта
	|		КОГДА 2
	|			ТОГДА &ВалютаУправленческогоУчета
	|		ИНАЧЕ АналитикаУчета.Организация.ВалютаРегламентированногоУчета
	|	КОНЕЦ,
	|	РасчетыПланОтгрузок.ДокументПлан,
	|	РасчетыПланОтгрузок.ДатаПлановогоПогашения,
	|	РасчетыПланОтгрузок.ДатаВозникновения,
	|	0,
	|	0,
	|	0,
	|	0,
	|	0,
	|	РасчетыПланОтгрузок.СуммаОстаток * КурсВалюты.Коэффициент
	|ИЗ
	|	РегистрНакопления.РасчетыСКлиентамиПланОтгрузок.Остатки(&ДатаОтчетаГраница, НЕ НераспределенныйАванс
	|		И АналитикаУчетаПоПартнерам В
	|				(ВЫБРАТЬ
	|					ВТ_АналитикаУчетаПоПартнерам.КлючАналитики
	|				ИЗ
	|					ВТ_АналитикаУчетаПоПартнерам)) КАК РасчетыПланОтгрузок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_АналитикаУчетаПоПартнерам КАК АналитикаУчета
	|			ПО РасчетыПланОтгрузок.АналитикаУчетаПоПартнерам = АналитикаУчета.КлючАналитики
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсВалюты
	|			ПО (КурсВалюты.Валюта = РасчетыПланОтгрузок.Валюта)
	|				И (КурсВалюты.Организация = АналитикаУчета.Организация)
	|ГДЕ
	|	(&ВключатьЗадолженность = 0
	|			ИЛИ &ВключатьЗадолженность = 2)
	|	И &ВключатьПланОтгрузок
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ТаблицаЗадолженностей.ДатаПлановогоПогашения КАК ДатаНачала,
	|	ГрафикиРаботы.Дата КАК ДатаОкончания,
	|	ВЫБОР
	|		КОГДА ГрафикиРаботы.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Рабочий)
	|				ИЛИ ГрафикиРаботы.ВидДня = ЗНАЧЕНИЕ(Перечисление.ВидыДнейПроизводственногоКалендаря.Предпраздничный)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РабочийДень
	|ПОМЕСТИТЬ Графики
	|ИЗ
	|	ТаблицаЗадолженностей КАК ТаблицаЗадолженностей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДанныеПроизводственногоКалендаря КАК ГрафикиРаботы
	|		ПО (ГрафикиРаботы.ПроизводственныйКалендарь = &Календарь)
	|ГДЕ
	|	ГрафикиРаботы.Дата МЕЖДУ ТаблицаЗадолженностей.ДатаПлановогоПогашения И &ДатаОтчета
	|	И ТаблицаЗадолженностей.ДатаПлановогоПогашения <> ДАТАВРЕМЯ(1, 1, 1)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.ДатаНачала КАК ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания КАК ДатаОкончания,
	|	ЕСТЬNULL(СУММА(Графики.РабочийДень), 0) КАК КоличествоДней
	|ПОМЕСТИТЬ РазностиДат
	|ИЗ
	|	Графики КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Графики КАК Графики
	|		ПО ВложенныйЗапрос.ДатаНачала = Графики.ДатаНачала
	|			И ВложенныйЗапрос.ДатаОкончания > Графики.ДатаОкончания
	|ГДЕ
	|	ВложенныйЗапрос.ДатаОкончания = НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.ДатаНачала,
	|	ВложенныйЗапрос.ДатаОкончания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&СтрокаСостояниеВзаиморасчетов КАК ГруппировкаВсего,
	|	ТаблицаЗадолженностей.Организация КАК Организация,
	|	ТаблицаЗадолженностей.Партнер КАК Партнер,
	|	ТаблицаЗадолженностей.Контрагент КАК Контрагент,
	|	ТаблицаЗадолженностей.Договор КАК Договор,
	|	ТаблицаЗадолженностей.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	ТаблицаЗадолженностей.ОбъектРасчетов КАК ОбъектРасчетов,
	|	ТаблицаЗадолженностей.Валюта КАК Валюта,
	|	ТаблицаЗадолженностей.РасчетныйДокумент КАК РасчетныйДокумент,
	|	ТаблицаЗадолженностей.ДатаПлановогоПогашения КАК ДатаПлановогоПогашения,
	|	ТаблицаЗадолженностей.ДатаВозникновения КАК ДатаВозникновения,
	|	ТаблицаЗадолженностей.НашДолг КАК НашДолг,
	|	ТаблицаЗадолженностей.НашДолгПросрочено КАК НашДолгПросрочено,
	|	ТаблицаЗадолженностей.НашДолгНеКонтролируется КАК НашДолгНеКонтролируется,
	|	ТаблицаЗадолженностей.ДолгКлиента КАК ДолгКлиента,
	|	ТаблицаЗадолженностей.ДолгКлиентаПросрочено КАК ДолгКлиентаПросрочено,
	|	ТаблицаЗадолженностей.КОтгрузке КАК КОтгрузке,
	|	ВЫБОР
	|		КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL
	|			ТОГДА ВЫБОР
	|					КОГДА РазностиДат.КоличествоДней > 0
	|						ТОГДА РазностиДат.КоличествоДней
	|					ИНАЧЕ 0
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ТаблицаЗадолженностей.НашДолг = 0
	|						ИЛИ ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА 0
	|				ИНАЧЕ ВЫБОР
	|						КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ) > 0
	|							ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ)
	|						ИНАЧЕ 0
	|					КОНЕЦ
	|			КОНЕЦ
	|	КОНЕЦ КАК КоличествоДней,
	|	ВЫБОР 
	|		КОГДА ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА &СтрокаДолгНеКонтролируется
	|		ИНАЧЕ ЕСТЬNULL(Интервалы.НаименованиеИнтервала, &СтрокаДолгНеПросрочен) 
	|	КОНЕЦ КАК НаименованиеИнтервала,
	|	ВЫБОР 
	|		КОГДА ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА -1
	|		ИНАЧЕ ЕСТЬNULL(Интервалы.НомерСтроки, 0)
	|	КОНЕЦ КАК НомерИнтервала,
	|	ВЫБОР 
	|		КОГДА ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА -1
	|		ИНАЧЕ ЕСТЬNULL(Интервалы.НижняяГраницаИнтервала, 0)
	|	КОНЕЦ КАК НижняяГраницаИнтервала
	|ИЗ
	|	ТаблицаЗадолженностей КАК ТаблицаЗадолженностей
	|		{ЛЕВОЕ СОЕДИНЕНИЕ РазностиДат КАК РазностиДат
	|		ПО (РазностиДат.ДатаНачала = ТаблицаЗадолженностей.ДатаПлановогоПогашения)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВариантыКлассификацииЗадолженности.Интервалы КАК Интервалы
	|		ПО (Интервалы.Ссылка = &ВариантКлассификацииЗадолженности)
	|			И (ВЫБОР
	|				КОГДА НЕ РазностиДат.КоличествоДней ЕСТЬ NULL
	|					ТОГДА ВЫБОР
	|							КОГДА РазностиДат.КоличествоДней > 0
	|								ТОГДА РазностиДат.КоличествоДней
	|							ИНАЧЕ 0
	|						КОНЕЦ
	|				ИНАЧЕ ВЫБОР
	|						КОГДА ТаблицаЗадолженностей.НашДолг = 0
	|								ИЛИ ТаблицаЗадолженностей.ДатаПлановогоПогашения = ДАТАВРЕМЯ(1, 1, 1)
	|							ТОГДА 0
	|						ИНАЧЕ ВЫБОР
	|								КОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ) > 0
	|									ТОГДА РАЗНОСТЬДАТ(ТаблицаЗадолженностей.ДатаПлановогоПогашения, &ДатаОтчета, ДЕНЬ)
	|								ИНАЧЕ 0
	|							КОНЕЦ
	|					КОНЕЦ
	|			КОНЕЦ МЕЖДУ Интервалы.НижняяГраницаИнтервала И Интервалы.ВерхняяГраницаИнтервала)}";

	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ТипыДокументовПлана", ПолучитьТипыДокументовПлана());
	
	Возврат ТекстЗапроса;
КонецФункции

Функция ПолучитьТипыДокументовПлана()
	
	ТекстТиповДокументов = ""; 
	
	
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ЗаказКлиента), ";
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ЗаявкаНаВозвратТоваровОтКлиента), ";
	ТекстТиповДокументов = ТекстТиповДокументов + "ТИП(Документ.ГрафикИсполненияДоговора)";
	
	Возврат ТекстТиповДокументов;
КонецФункции

Процедура УстановитьКалендарь(КомпоновщикНастроек, ПользовательскиеНастройкиМодифицированы)
	ПараметрВариантКлассификацииЗадолженности = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "ВариантКлассификацииЗадолженности");
	ПараметрКалендарь = КомпоновкаДанныхКлиентСервер.ПолучитьПараметр(КомпоновщикНастроек, "Календарь");
	
	Если ПараметрВариантКлассификацииЗадолженности.Значение.Календарь.Пустая() Тогда
		ОсновнойКалендарьПредприятия = Константы.ОсновнойКалендарьПредприятия.Получить();
		Если Не ОсновнойКалендарьПредприятия.Пустая() Тогда
			КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Календарь", ОсновнойКалендарьПредприятия);
		
			ПользовательскиеНастройкиМодифицированы = Истина;
		КонецЕсли;
	Иначе
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(КомпоновщикНастроек, "Календарь", ПараметрВариантКлассификацииЗадолженности.Значение.Календарь);
		
		ПользовательскиеНастройкиМодифицированы = Истина;
	КонецЕсли;
КонецПроцедуры

Процедура НайтиВыбранныеПоляРекурсивно(КоллекцияЭлементов, МассивЭлементов)

	Для каждого Элемент Из КоллекцияЭлементов Цикл
		
		Если ТипЗнч(Элемент) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
			Если Элемент.Использование Тогда
				МассивЭлементов.Добавить(Элемент);
			КонецЕсли;
		Иначе
			НайтиВыбранныеПоляРекурсивно(Элемент.Элементы, МассивЭлементов);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#КонецЕсли