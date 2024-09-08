﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	ЕстьПравоНастройкиОбмена = НастройкиЭДО.ЕстьПравоНастройкиОбмена();
	
	Элементы.НастройкиОтправкиСоздатьПоОрганизации.Видимость = ЕстьПравоНастройкиОбмена;
	Элементы.НастройкиОтправкиСоздатьПоДоговору.Видимость = ЕстьПравоНастройкиОбмена;
	
	Параметры.Свойство("Контрагент", Контрагент);
	
	ЗаполнитьДеревоНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьТекущиеДелаЭДО" Тогда
		 ЗаполнитьДеревоНастроек();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиОтправки

&НаКлиенте
Процедура НастройкиОтправкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.НастройкиОтражения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ОтражениеВУчетеЭДОКлиент.НовыеПараметрыФормыНастройкиОтраженияВУчете();
	ПараметрыФормы.Организация = ТекущиеДанные.Организация;
	ПараметрыФормы.ИдентификаторКонтрагента = ТекущиеДанные.ИдентификаторКонтрагента;
	ПараметрыФормы.ИдентификаторОрганизации = ТекущиеДанные.ИдентификаторОрганизации;
	ПараметрыФормы.Контрагент = Контрагент;
	
	ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
	ПараметрыОткрытия.Владелец = ЭтотОбъект;
	
	ОтражениеВУчетеЭДОКлиент.ОткрытьНастройкуОтраженияВУчете(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоОрганизации(Команда)
	
	ПараметрыФормы = ОтражениеВУчетеЭДОКлиент.НовыеПараметрыФормыНастройкиОтраженияВУчете();
	ПараметрыФормы.Контрагент = Контрагент;
	ПараметрыФормы.Организация = Контрагент;
	ПараметрыФормы.СоздатьНовыйПоИдентификаторам = Ложь;
	
	ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
	ПараметрыОткрытия.Владелец = ЭтотОбъект;
	
	ОтражениеВУчетеЭДОКлиент.ОткрытьНастройкуОтраженияВУчете(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоДоговору(Команда)
	
	ТекущиеДанные = Элементы.НастройкиОтражения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = ОтражениеВУчетеЭДОКлиент.НовыеПараметрыФормыНастройкиОтраженияВУчете();
	ПараметрыФормы.Контрагент = Контрагент;
	ПараметрыФормы.Организация = ТекущиеДанные.Организация;
	ПараметрыФормы.СоздатьНовыйПоИдентификаторам = Истина;
	
	ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
	ПараметрыОткрытия.Владелец = ЭтотОбъект;
	
	ОтражениеВУчетеЭДОКлиент.ОткрытьНастройкуОтраженияВУчете(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Расширенный'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийТекст);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиОтправки.РасширенныйРежим");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиОтправкиСпособОтражения");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоНастроек()
	
	Запросы = Новый Массив;
	ЗапросАбонентов = РаботаСАбонентамиЭДО.ЗапросАбонентовЭДО("АбонентыЭДО");
	Запросы.Добавить(ЗапросАбонентов);
	
	ЗапросУчетныхЗаписей = СинхронизацияЭДО.ЗапросУчетныхЗаписей("УчетныеЗаписиЭДО");
	Запросы.Добавить(ЗапросУчетныхЗаписей);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	НастройкиПолученияЭлектронныхДокументов.Получатель КАК Получатель
		|ИЗ
		|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
		|ГДЕ
		|	НастройкиПолученияЭлектронныхДокументов.Отправитель = &Контрагент
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкиПолученияЭлектронныхДокументов.Получатель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НастройкиПолученияЭлектронныхДокументов.Отправитель КАК Отправитель,
		|	НастройкиПолученияЭлектронныхДокументов.Получатель КАК Получатель,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя КАК ИдентификаторОтправителя,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя КАК ИдентификаторПолучателя,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА НастройкиПолученияЭлектронныхДокументов.СпособОбработки = ""Вручную""
		|				ТОГДА ""Вручную""
		|			ИНАЧЕ ""Автоматически""
		|		КОНЕЦ) КАК СпособОбработки,
		|	ЕСТЬNULL(УчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи, НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя) КАК ИдентификаторПолучателяНаименование,
		|	ЕСТЬNULL(АбонентыЭДО.КраткоеОписание, НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя) КАК ИдентификаторОтправителяНаименование
		|ИЗ
		|	РегистрСведений.НастройкиПолученияЭлектронныхДокументов КАК НастройкиПолученияЭлектронныхДокументов
		|		ЛЕВОЕ СОЕДИНЕНИЕ АбонентыЭДО КАК АбонентыЭДО
		|		ПО НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя = АбонентыЭДО.ИдентификаторЭДО
		|		ЛЕВОЕ СОЕДИНЕНИЕ УчетныеЗаписиЭДО КАК УчетныеЗаписиЭДО
		|		ПО НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя = УчетныеЗаписиЭДО.ИдентификаторЭДО
		|ГДЕ
		|	НастройкиПолученияЭлектронныхДокументов.Отправитель = &Контрагент
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкиПолученияЭлектронныхДокументов.Отправитель,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя,
		|	НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя,
		|	НастройкиПолученияЭлектронныхДокументов.Получатель,
		|	ЕСТЬNULL(УчетныеЗаписиЭДО.НаименованиеУчетнойЗаписи, НастройкиПолученияЭлектронныхДокументов.ИдентификаторПолучателя),
		|	ЕСТЬNULL(АбонентыЭДО.КраткоеОписание, НастройкиПолученияЭлектронныхДокументов.ИдентификаторОтправителя)";
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	
	ИтоговыйЗапрос.УстановитьПараметр("Контрагент", Контрагент);
	
	РезультатыЗапроса = ИтоговыйЗапрос.ВыполнитьПакет();
	
	ТаблицаПолучателей         = РезультатыЗапроса[2].Выгрузить();
	ТаблицаНастроекКонтрагента = РезультатыЗапроса[3].Выгрузить();
	ТаблицаНастроекКонтрагента.Индексы.Добавить("Получатель");
	
	ЭлементыДерева = НастройкиОтражения.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	
	Для Каждого СтрокаТЧ Из ТаблицаПолучателей Цикл
		
		НоваяСтрока = ЭлементыДерева.Добавить();
		НоваяСтрока.Организация   = СтрокаТЧ.Получатель;
		НоваяСтрока.Представление = СтрокаТЧ.Получатель;
		
		Отбор = Новый Структура("Получатель", СтрокаТЧ.Получатель);
		НайденныеСтроки = ТаблицаНастроекКонтрагента.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество()  = 1 Тогда
			
			НоваяСтрока.СпособОтражения = НайденныеСтроки[0].СпособОбработки;
			
		ИначеЕсли НайденныеСтроки.Количество() > 1 Тогда
			
			Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
				
				Если Не ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторОтправителя) Тогда
					НоваяСтрока.СпособОтражения = СтрокаТаблицы.СпособОбработки;
					Продолжить;
				КонецЕсли;
				
				Договор = НоваяСтрока.ПолучитьЭлементы().Добавить();
				Договор.Организация = СтрокаТаблицы.Получатель;
				Договор.ИдентификаторКонтрагента = СтрокаТаблицы.ИдентификаторОтправителя;
				Договор.ИдентификаторОрганизации = СтрокаТаблицы.ИдентификаторПолучателя;
				Договор.Представление = СтрокаТаблицы.ИдентификаторПолучателяНаименование;
				Если ЗначениеЗаполнено(СтрокаТаблицы.ИдентификаторОтправителяНаименование) Тогда
					Договор.Представление = Договор.Представление + " - " + СтрокаТаблицы.ИдентификаторОтправителяНаименование;
				КонецЕсли;
				Договор.СпособОтражения = СтрокаТаблицы.СпособОбработки;
				
				НоваяСтрока.РасширенныйРежим = Истина;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.НастройкиОтправкиСоздатьПоДоговору.Доступность = НастройкиОтражения.ПолучитьЭлементы().Количество();
	
КонецПроцедуры

#КонецОбласти