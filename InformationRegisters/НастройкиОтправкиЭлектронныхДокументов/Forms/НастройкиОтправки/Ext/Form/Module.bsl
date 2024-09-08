﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПравоНастройкиОбмена         = НастройкиЭДО.ЕстьПравоНастройкиОбмена();
	ИспользуютсяДоговорыКонтрагентов = ИнтеграцияЭДО.ИспользуютсяДоговорыКонтрагентов();
	
	Элементы.НастройкиОтправкиСоздатьПоОрганизации.Видимость = ЕстьПравоНастройкиОбмена;
	Если Не ИспользуютсяДоговорыКонтрагентов Тогда
		Элементы.НастройкиОтправкиСоздатьПоОрганизации.Заголовок = НСтр("ru = 'Создать'");
		Элементы.НастройкиОтправкиОрганизация.Заголовок = НСтр("ru = 'Организация'");
	КонецЕсли;
	
	Элементы.НастройкиОтправкиСоздатьПоДоговору.Видимость = ЕстьПравоНастройкиОбмена И ИспользуютсяДоговорыКонтрагентов;
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("Контрагент", Контрагент);
	
	ЗаполнитьДеревоНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьТекущиеДелаЭДО" Тогда
		 ЗаполнитьДеревоНастроек();
	ИначеЕсли ИмяСобытия = "ИзмененСтатусПриглашения" И Параметр = Контрагент Тогда
		 ЗаполнитьДеревоНастроек();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНастройкиОтправки

&НаКлиенте
Процедура НастройкиОтправкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.НастройкиОтправки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлючНастроекОтправки = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
	КлючНастроекОтправки.Отправитель = ТекущиеДанные.Организация;
	КлючНастроекОтправки.Получатель = Контрагент;
	КлючНастроекОтправки.Договор = ТекущиеДанные.Договор;
	
	ПараметрыФормы = НастройкиОтправкиЭДОКлиент.НовыеПараметрыФормыНастроекОтправки();
	ПараметрыФормы.КлючНастроекОтправки = КлючНастроекОтправки;
	
	ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
	ПараметрыОткрытия.Владелец = ЭтотОбъект;
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкуОтправки(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоОрганизации(Команда)
	
	КлючНастроекОтправки = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
	КлючНастроекОтправки.Получатель = Контрагент;
	
	ПараметрыФормы = НастройкиОтправкиЭДОКлиент.НовыеПараметрыФормыНастроекОтправки();
	ПараметрыФормы.КлючНастроекОтправки = КлючНастроекОтправки;
	ПараметрыФормы.СоздатьПоДоговору = Ложь;
	
	ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
	ПараметрыОткрытия.Владелец = ЭтотОбъект;
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкуОтправки(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоДоговору(Команда)
	
	ТекущиеДанные = Элементы.НастройкиОтправки.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлючНастроекОтправки = НастройкиЭДОКлиентСервер.НовыйКлючНастроекОтправки();
	КлючНастроекОтправки.Отправитель = ТекущиеДанные.Организация;
	КлючНастроекОтправки.Получатель = Контрагент;
	
	ПараметрыФормы = НастройкиОтправкиЭДОКлиент.НовыеПараметрыФормыНастроекОтправки();
	ПараметрыФормы.КлючНастроекОтправки = КлючНастроекОтправки;
	ПараметрыФормы.СоздатьПоДоговору = Истина;
	
	ПараметрыОткрытия = ОбщегоНазначенияБЭДКлиент.НовыеПараметрыОткрытияФормы();
	ПараметрыОткрытия.Владелец = ЭтотОбъект;
	НастройкиОтправкиЭДОКлиент.ОткрытьНастройкуОтправки(ПараметрыФормы, ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Включен расширенный режим>'"));
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста",ЦветаСтиля.ПоясняющийТекст);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("НастройкиОтправки.РасширенныйРежим");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных("НастройкиОтправкиСпособОбмена");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоНастроек()
	
	Запросы = Новый Массив;
	
	ЗапросПриглашений = ПриглашенияЭДО.ЗапросПриглашений("ПриглашенияКОбменуЭлектроннымиДокументами");
	
	Запросы.Добавить(ЗапросПриглашений);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель КАК Отправитель,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НастройкиОтправкиЭлектронныхДокументов.Договор) КАК КоличествоСтатусов
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументов КАК НастройкиОтправкиЭлектронныхДокументов
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументов.Получатель = &Получатель
		|СГРУППИРОВАТЬ ПО
		|	НастройкиОтправкиЭлектронныхДокументов.Отправитель
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель КАК Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель КАК Получатель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор КАК Договор,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторОтправителя) КАК
		|		КоличествоИдентификаторовОтправителя,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторПолучателя) КАК
		|		КоличествоИдентификаторовПолучателя,
		|	ЕСТЬNULL(ПриглашенияКОбменуЭлектроннымиДокументами.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусыПриглашений.Отклонено)) КАК
		|		Статус
		|ИЗ
		|	РегистрСведений.НастройкиОтправкиЭлектронныхДокументовПоВидам КАК НастройкиОтправкиЭлектронныхДокументовПоВидам
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПриглашенияКОбменуЭлектроннымиДокументами КАК ПриглашенияКОбменуЭлектроннымиДокументами
		|		ПО НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторОтправителя = ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторОрганизации
		|		И
		|			НастройкиОтправкиЭлектронныхДокументовПоВидам.ИдентификаторПолучателя = ПриглашенияКОбменуЭлектроннымиДокументами.ИдентификаторКонтрагента
		|ГДЕ
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель = &Получатель
		|СГРУППИРОВАТЬ ПО
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Отправитель,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Договор,
		|	НастройкиОтправкиЭлектронныхДокументовПоВидам.Получатель,
		|	ЕСТЬNULL(ПриглашенияКОбменуЭлектроннымиДокументами.Статус, ЗНАЧЕНИЕ(Перечисление.СтатусыПриглашений.Отклонено))";
	
	ИтоговыйЗапрос = ОбщегоНазначенияБЭД.СоединитьЗапросы(Запрос, Запросы);
	ИтоговыйЗапрос.УстановитьПараметр("Получатель", Контрагент);
	
	РезультатыЗапроса = ИтоговыйЗапрос.ВыполнитьПакет();
	
	ТаблицаОтправителей        = РезультатыЗапроса[1].Выгрузить();
	ТаблицаНастроекКонтрагента = РезультатыЗапроса[2].Выгрузить();
	ТаблицаНастроекКонтрагента.Индексы.Добавить("Отправитель");
	
	ЭлементыДерева = НастройкиОтправки.ПолучитьЭлементы();
	ЭлементыДерева.Очистить();
	
	Для Каждого СтрокаТЧ Из ТаблицаОтправителей Цикл
		
		НоваяСтрока = ЭлементыДерева.Добавить();
		НоваяСтрока.Организация   = СтрокаТЧ.Отправитель;
		НоваяСтрока.Представление = СтрокаТЧ.Отправитель;
		
		Отбор = Новый Структура("Отправитель", СтрокаТЧ.Отправитель);
		НайденныеСтроки = ТаблицаНастроекКонтрагента.НайтиСтроки(Отбор);
		
		Если НайденныеСтроки.Количество() = 1 Тогда
			
			НоваяСтрока.Статус = НайденныеСтроки[0].Статус;
			НоваяСтрока.РасширенныйРежим = НайденныеСтроки[0].КоличествоИдентификаторовОтправителя <> 1
						Или НайденныеСтроки[0].КоличествоИдентификаторовПолучателя <> 1;
						
		ИначеЕсли НайденныеСтроки.Количество() > 1 Тогда
			
			Для Каждого СтрокаТаблицы Из НайденныеСтроки Цикл
				
				Если Не ЗначениеЗаполнено(СтрокаТаблицы.Договор) Тогда 
					НоваяСтрока.Статус = СтрокаТаблицы.Статус;
					НоваяСтрока.РасширенныйРежим = СтрокаТаблицы.КоличествоИдентификаторовОтправителя <> 1
						Или СтрокаТаблицы.КоличествоИдентификаторовПолучателя <> 1;
					Продолжить;
				КонецЕсли;
				
				Договор = НоваяСтрока.ПолучитьЭлементы().Добавить();
				Договор.Организация = СтрокаТаблицы.Отправитель;
				Договор.Договор = СтрокаТаблицы.Договор;
				Договор.Представление = СтрокаТаблицы.Договор;
				Договор.Статус = СтрокаТаблицы.Статус;
				НоваяСтрока.РасширенныйРежим = СтрокаТаблицы.КоличествоИдентификаторовОтправителя <> 1
						Или СтрокаТаблицы.КоличествоИдентификаторовПолучателя <> 1;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.НастройкиОтправкиСоздатьПоДоговору.Доступность = НастройкиОтправки.ПолучитьЭлементы().Количество();
	
КонецПроцедуры

#КонецОбласти