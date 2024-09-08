﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	ЗаполнитьТаблицуДокументовНаСервере();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДокументыВозвратовИПриемов

&НаКлиенте
Процедура ДокументыВозвратовИПриемовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Поле.Имя = "ДокументыВозвратовИПриемовДокументВозвратаСостояние" 
		ИЛИ Поле.Имя = "ДокументыВозвратовИПриемовДокументПриемаСостояние"
		Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяСтрока = Элементы.ДокументыВозвратовИПриемов.ТекущиеДанные;
	ИмяРеквизитаТаблицы = СтрЗаменить(Поле.Имя, "ДокументыВозвратовИПриемов", "");
	ЗначениеВЯчейке = ТекущаяСтрока[ИмяРеквизитаТаблицы];
	
	Если ЗначениеЗаполнено(ЗначениеВЯчейке) Тогда
	
		ОписаниеОповещения = Новый ОписаниеОповещения("ДокументыВозвратовИПриемовВыборЗавершение", ЭтаФорма, Новый Структура);
		
		Если ИмяРеквизитаТаблицы = "ДокументВозврата" Тогда
			ОткрытьФорму("Документ.ВозвратТоваровПоставщику.ФормаОбъекта", 
				Новый Структура("Ключ", ЗначениеВЯчейке),
				ЭтаФорма, , , ,
				ОписаниеОповещения);
		ИначеЕсли ИмяРеквизитаТаблицы = "ДокументПриемаНаКомиссию" Тогда
			ОткрытьФорму("Документ.ПриобретениеТоваровУслуг.ФормаОбъекта", 
				Новый Структура("Ключ", ЗначениеВЯчейке),
				ЭтаФорма, , , ,
				ОписаниеОповещения);
		Иначе
			ПоказатьЗначение(Неопределено, ЗначениеВЯчейке);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьТаблицуДокументов(Команда)

	ЗаполнитьТаблицуДокументовНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьВозвратИПрием(Команда)
	
	ОчиститьСообщения();
	
	ТекущаяСтрока = Элементы.ДокументыВозвратовИПриемов.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru='Не указана строка таблицы, для которой необходимо создать документы.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
		
	КонецЕсли;
	
	ОформитьВозвратИПриемВСтроке(ТекущаяСтрока);
	
	ЗаполнитьТаблицуДокументовНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьВсеВозвратыИПриемы(Команда)
	
	ОчиститьСообщения();
	
	Для Каждого ТекСтрока Из ДокументыВозвратовИПриемов Цикл
		ОформитьВозвратИПриемВСтроке(ТекСтрока);
	КонецЦикла;
	
	ЗаполнитьТаблицуДокументовНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ДокументыВозвратовИПриемовВыборЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ЗаполнитьТаблицуДокументовНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуДокументовНаСервере()

	ТаблицаДокументов = Обработки.ПанельАдминистрированияУчетПрослеживаемыхТоваров.ПолучитьДокументыКОформлениюПоПрослеживаемымТоварамНаКомиссии();
	ДокументыВозвратовИПриемов.Загрузить(ТаблицаДокументов);

КонецПроцедуры

&НаКлиенте
Процедура ОформитьВозвратИПриемВСтроке(ТекущаяСтрока)
	
	ПараметрыЗаполнения = Новый Структура("Организация,Комитент,Соглашение,Склад");
	ЗаполнитьЗначенияСвойств(ПараметрыЗаполнения, ТекущаяСтрока);
	
	Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ДокументВозврата) Тогда
		ТекущаяСтрока.ДокументВозврата = ОформитьВозвратТоваровПоставщику(ПараметрыЗаполнения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ДокументВозврата) 
		И НЕ ЗначениеЗаполнено(ТекущаяСтрока.ДокументПриемаНаКомиссию) 
		Тогда
		ТекущаяСтрока.ДокументПриемаНаКомиссию = ОформитьПриобретениеТоваровУслуг(ТекущаяСтрока.ДокументВозврата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОформитьВозвратТоваровПоставщику(ПараметрыЗаполнения)
	
	ДокументВозврата = ПредопределенноеЗначение("Документ.ВозвратТоваровПоставщику.ПустаяСсылка");
	
	НовыйДокумент = Документы.ВозвратТоваровПоставщику.СоздатьДокумент();
	
	ЗаполнитьШапкуДокументаВозврата(НовыйДокумент, ПараметрыЗаполнения);
	ЗаполнитьТаблицуТоваровДокументаВозврата(НовыйДокумент, ПараметрыЗаполнения);
	ЗаполнитьДоговорПоПоступлениям(НовыйДокумент);
	
	Попытка
		
		Если НовыйДокумент.ПроверитьЗаполнение() Тогда
			НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
		Иначе
			НовыйДокумент.Записать();
		КонецЕсли;
		
		ДокументВозврата = НовыйДокумент.Ссылка;
	Исключение
		
		ТекстСообщения = СтрШаблон(НСтр("ru='Не удалось создать документ возврата по причине: %1.'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецПопытки;
	
	Возврат ДокументВозврата;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьШапкуДокументаВозврата(ДокументОбъект, ПараметрыЗаполнения)
	
	ДатаНачалаПрослеживаемости = УчетПрослеживаемыхТоваровЛокализация.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров();
	
	Если ДатаНачалаПрослеживаемости > ТекущаяДатаСеанса() Тогда
		ДокументОбъект.Дата = КонецДня(ТекущаяДатаСеанса() - 24 * 3600);
	Иначе
		ДокументОбъект.Дата = КонецДня(ДатаНачалаПрослеживаемости - 24 * 3600);
	КонецЕсли;
	
	ПараметрыЗаполнения.Вставить("КорректировкаОстатковРНПТ", Истина);
	ПараметрыЗаполнения.Вставить("Партнер", ПараметрыЗаполнения.Комитент);
	ПараметрыЗаполнения.Вставить("ХозяйственнаяОперация", ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВозвратТоваровКомитенту"));
	
	ЗаполнитьЗначенияСвойств(ДокументОбъект, ПараметрыЗаполнения);
	ДокументОбъект.Заполнить(ПараметрыЗаполнения);
	ДокументОбъект.Соглашение = ПараметрыЗаполнения.Соглашение;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуТоваровДокументаВозврата(ДокументОбъект, ПараметрыЗаполнения)
	
	ЗапросТоваров = Новый Запрос;
	ЗапросТоваров.Текст = ТекстЗапросаТоваров();
	ЗапросТоваров.УстановитьПараметр("ДатаНачалаПрослеживаемости", УчетПрослеживаемыхТоваровЛокализация.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров());
	ЗапросТоваров.УстановитьПараметр("Организация", ПараметрыЗаполнения.Организация);
	ЗапросТоваров.УстановитьПараметр("Комитент", ПараметрыЗаполнения.Комитент);
	ЗапросТоваров.УстановитьПараметр("Соглашение", ПараметрыЗаполнения.Соглашение);
	ЗапросТоваров.УстановитьПараметр("Склад", ПараметрыЗаполнения.Склад);
	
	ТаблицаТоваров = ЗапросТоваров.Выполнить().Выгрузить();
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьКоличествоУпаковок");
	СтруктураДействий.Вставить("ЗаполнитьНоменклатуруПартнераПоНоменклатуре", ДокументОбъект.Партнер);
	СтруктураДействий.Вставить("ПроверитьЗаполнитьУпаковкуПоВладельцу", ПредопределенноеЗначение("Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка"));
	СтруктураДействий.Вставить("ЗаполнитьСтавкуНДС", ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтавкиНДС(ДокументОбъект));
		
	Для Каждого ТекСтрока Из ТаблицаТоваров Цикл
		
		НоваяСтрока = ДокументОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,ТекСтрока);
		
		ОбработкаТабличнойЧастиСервер.ОбработатьСтрокуТЧ(НоваяСтрока, СтруктураДействий, Неопределено);
			
	КонецЦикла;
	
	ЗакупкиСервер.ЗаполнитьПоступленияИЦены(ДокументОбъект, "Товары");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоговорПоПоступлениям(ДокументОбъект)
	
	Если ДокументОбъект.Товары.Количество() <> 0 Тогда
		
		ДокументПоступления = ДокументОбъект.Товары[0].ДокументПоступления;
		
		Если ЗначениеЗаполнено(ДокументПоступления) Тогда
			ДокументОбъект.Договор = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументПоступления, "Договор");
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры
	
&НаСервере
Функция ОформитьПриобретениеТоваровУслуг(ДокументВозврата)

	ДокументПриема = ПредопределенноеЗначение("Документ.ПриобретениеТоваровУслуг.ПустаяСсылка");
	
	ДокументВозвратаПроведен = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументВозврата, "Проведен");
	
	Если НЕ ДокументВозвратаПроведен Тогда
		
		ТекстСообщения = НСтр("ru='Документ приема может быть введен только на основании проведенного документа возврата.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Возврат ДокументПриема;
		
	КонецЕсли;
	
	НовыйДокумент = Документы.ПриобретениеТоваровУслуг.СоздатьДокумент();
	
	ДатаНачалаПрослеживаемости = УчетПрослеживаемыхТоваровЛокализация.ДатаНачалаУчетаПрослеживаемыхИмпортныхТоваров();
	
	Если ДатаНачалаПрослеживаемости > ТекущаяДатаСеанса() Тогда
		НовыйДокумент.Дата = КонецДня(ТекущаяДатаСеанса() - 24 * 3600);
	Иначе
		НовыйДокумент.Дата = КонецДня(ДатаНачалаПрослеживаемости - 24 * 3600);
	КонецЕсли;
	
	НовыйДокумент.КорректировкаОстатковРНПТ = Истина;
	НовыйДокумент.Заполнить(ДокументВозврата);

	Попытка
		НовыйДокумент.Записать();
		ДокументПриема = НовыйДокумент.Ссылка;
	Исключение
		
		ТекстСообщения = СтрШаблон(НСтр("ru='Не удалось создать документ приема по причине: %1.'"), КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
	КонецПопытки;
	
	Возврат ДокументПриема;
		
КонецФункции

&НаСервере
Функция ТекстЗапросаТоваров()
	
	Возврат
	
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЗапасов.Ссылка КАК ВидЗапасов
	|ПОМЕСТИТЬ ВидыЗапасовКомиссия
	|ИЗ
	|	Справочник.ВидыЗапасов КАК ВидыЗапасов
	|ГДЕ
	|	ВидыЗапасов.ТипЗапасов = ЗНАЧЕНИЕ(Перечисление.ТипыЗапасов.КомиссионныйТовар)
	|	И НЕ ВидыЗапасов.РеализацияЗапасовДругойОрганизации
	|	И ВидыЗапасов.ВладелецТовара ССЫЛКА Справочник.Партнеры
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Аналитика.Номенклатура КАК Номенклатура,
	|	Аналитика.Характеристика КАК Характеристика,
	|	Аналитика.Назначение КАК Назначение,
	|	Аналитика.Серия КАК Серия,
	|	ТоварыОрганизаций.НомерГТД КАК НомерГТД,
	|	ТоварыОрганизаций.КоличествоОстаток КАК Количество
	|ИЗ
	|	РегистрНакопления.ТоварыОрганизаций.Остатки(&ДатаНачалаПрослеживаемости, ВидЗапасов В
	|		(ВЫБРАТЬ
	|			ВидЗапасов
	|		ИЗ
	|			ВидыЗапасовКомиссия КАК ВидыЗапасовКомиссия)) КАК ТоварыОрганизаций
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК Аналитика
	|		ПО ТоварыОрганизаций.АналитикаУчетаНоменклатуры = Аналитика.Ссылка
	|ГДЕ
	|	ЕСТЬNULL(Аналитика.Номенклатура.ПрослеживаемыйТовар, ЛОЖЬ)
	|	И НЕ ЕСТЬNULL(ТоварыОрганизаций.НомерГТД.ТипНомераГТД, ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.ПустаяСсылка)) В
	|			(ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.НомерРНПТ),
	|			ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.НомерРНПТКомплекта))
	|	И ТоварыОрганизаций.КоличествоОстаток > 0
	|	И ТоварыОрганизаций.Организация = &Организация
	|	И ТоварыОрганизаций.ВидЗапасов.ВладелецТовара = &Комитент
	|	И ТоварыОрганизаций.ВидЗапасов.Соглашение = &Соглашение
	|	И Аналитика.МестоХранения = &Склад";

КонецФункции

#КонецОбласти