﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	СписокДублейИнцидентов = Новый Массив;
	
	Если Параметры.Свойство("СписокИнцидентов", СписокДублейИнцидентов) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ссылка", СписокДублейИнцидентов, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
	КонецЕсли;
	
	Если Параметры.Свойство("РежимВыбора") И Параметры.РежимВыбора Тогда
		Элементы.Список.РежимВыбора = Истина;
	КонецЕсли;
	
	УстановитьПериод();
	
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборЖелаемаяДата.СписокВыбора);
	
	ВосстановитьНастройкиФормыПриСоздании(); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		СохранитьНастройкиФормы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ПериодПриИзменении(Элемент) 
	
	СохранитьНастройкиФормы();
	УстановитьОтборПоПериоду(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	УстановитьОтборПоАвтору(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидИнцидентаПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	УстановитьОтборПоВидуИнцидента(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКритичностьПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	УстановитьОтборПоКритичности(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	УстановитьОтборПоОтветственному(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСтатусПриИзменении(Элемент)
	
	СохранитьНастройкиФормы();
	УстановитьОтборПоСтатусу(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеНастройками

&НаСервере
Процедура ВосстановитьНастройкиФормыПриСоздании()
	
	НастройкиФормы = ХранилищеНастроекДанныхФорм.Загрузить(
		МенеджерНастроекКлючОбъекта(), МенеджерНастроекКлючНастроек());
	Если ЗначениеЗаполнено(НастройкиФормы) Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, НастройкиФормы);
	КонецЕсли; 
	
	УстановитьОтборПоАвтору(ЭтаФорма);
	УстановитьОтборПоВидуИнцидента(ЭтаФорма);
	УстановитьОтборПоКритичности(ЭтаФорма);
	УстановитьОтборПоОтветственному(ЭтаФорма);
	УстановитьОтборПоПериоду(ЭтаФорма);
	УстановитьОтборПоСтатусу(ЭтаФорма);
	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, Элементы.ОтборЖелаемаяДата.СписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиФормы()
	
	НастройкиФормы = СохраняемыеНастройкиФормы();
	
	ЗаполнитьЗначенияСвойств(НастройкиФормы, ЭтаФорма);
	ХранилищеНастроекДанныхФорм.Сохранить(
		МенеджерНастроекКлючОбъекта(), МенеджерНастроекКлючНастроек(), НастройкиФормы);
	
КонецПроцедуры

&НаСервере
Функция СохраняемыеНастройкиФормы()
	
	Результат = Новый Структура;
	Результат.Вставить("ОтборПериод");
	Результат.Вставить("ОтборВидИнцидента");
	Результат.Вставить("ОтборКритичность");
	Результат.Вставить("ОтборОтветственный");
	Результат.Вставить("ОтборАвтор");
	Результат.Вставить("ОтборСтатус");
	Результат.Вставить("Актуальность");
	Результат.Вставить("ДатаСобытия");
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция МенеджерНастроекКлючОбъекта()
	
	Возврат "Инциденты";
	
КонецФункции

&НаСервере
Функция МенеджерНастроекКлючНастроек()
	
	Возврат "НастройкиФормы";
	
КонецФункции

#КонецОбласти 

#Область ОбслуживаниеФормы

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.ДатаРегистрации", "ДатаРегистрации");

	// Критичность
	УстановитьУсловноеОформлениеПоляКритичность();
	
	// выделение цветом просроченного инцидента
	#Область ПросроченныеИнциденты
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ЖелаемаяДатаЗакрытия");
	
	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЖелаемаяДатаЗакрытия");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = ТекущаяДатаСеанса();
	
	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыИнцидентов.Зарегистрирован;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныйДокумент);
	
	#КонецОбласти
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформлениеПоляКритичность()
	
	Справочники.КритичностьИнцидентов.УстановитьУсловноеОформлениеПоляКритичность(ЭтотОбъект, "Список", "Критичность", "Критичность", Истина, "ОтборКритичность", "ОтборКритичность");
	
КонецПроцедуры

#КонецОбласти

#Область НастройкаСписка

&НаСервере
Процедура УстановитьПериод()
	
	ТекущаяДата = ТекущаяДатаСеанса();
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДата);
	
КонецПроцедуры

#КонецОбласти

#Область Отборы

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоАвтору(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Автор", 
		Форма.ОтборАвтор,
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборАвтор));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоСтатусу(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Статус",
		Форма.ОтборСтатус,
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборСтатус));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоОтветственному(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Исполнитель", 
		Форма.ОтборОтветственный,
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборОтветственный));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоКритичности(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"Критичность", 
		Форма.ОтборКритичность,
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборКритичность));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоВидуИнцидента(Форма)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Форма.Список,
		"ВидИнцидента", 
		Форма.ОтборВидИнцидента,
		ВидСравненияКомпоновкиДанных.Равно,
		, 
		ЗначениеЗаполнено(Форма.ОтборВидИнцидента));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборПоПериоду(Форма)
	
	Если ЗначениеЗаполнено(Форма.ОтборПериод.ДатаНачала) Тогда
		
		ГруппаЭлементов = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
			Форма.Список.Отбор.Элементы,
			"ГруппаНачало",
			ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаЭлементов,
			"ДатаРегистрации", 
			ВидСравненияКомпоновкиДанных.БольшеИлиРавно, 
			Форма.ОтборПериод.ДатаНачала);
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаЭлементов,
			"ДатаРегистрации", 
			ВидСравненияКомпоновкиДанных.НеЗаполнено);
			
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
			Форма.Список.Отбор,
			"ДатаРегистрации");
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Форма.ОтборПериод.ДатаОкончания) Тогда
		
		ГруппаЭлементов = ОбщегоНазначенияКлиентСервер.СоздатьГруппуЭлементовОтбора(
			Форма.Список.Отбор.Элементы,
			"ГруппаОкончание",
			ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли);
		
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаЭлементов,
			"ДатаРегистрации", 
			ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, 
			Форма.ОтборПериод.ДатаОкончания);
			
		ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(
			ГруппаЭлементов,
			"ДатаРегистрации", 
			ВидСравненияКомпоновкиДанных.НеЗаполнено);
			
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(
			Форма.Список.Отбор,
			"ДатаРегистрации");
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЖелаемаяДатаПриИзменении(Элемент) 
	
	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, Элементы.ОтборЖелаемаяДата.СписокВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборЖелаемаяДатаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
		ОбщегоНазначенияУТКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность",
		"ОтборЖелаемаяДата",
		"ДатаСобытия");
		
КонецПроцедуры

&НаКлиенте
Процедура ОтборЖелаемаяДатаОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеИнцидентыНажатие(Элемент)
	
	ОчиститьОтбор();
	
КонецПроцедуры 

&НаКлиенте
Процедура ДекорацияНаМнеНажатие(Элемент)   
	
	ОчиститьОтбор();
	ДекорацияНаМнеНажатиеСервер();
	УстановитьОтборПоОтветственному(ЭтаФорма);
	УстановитьОтборПоСтатусу(ЭтаФорма);

КонецПроцедуры 

&НаКлиенте
Процедура ДекорацияПросроченоНажатие(Элемент) 
	
	ОчиститьОтбор();
	ДекорацияПросроченоНажатиеНаСервере();
	УстановитьОтборПоСтатусу(ЭтаФорма);

	Если ЗначениеЗаполнено(ДатаСобытия) Тогда
		Представление = НСтр("ru='Просрочен'");
		Актуальность = Представление;
		Элементы["ОтборЖелаемаяДата"].СписокВыбора.НайтиПоЗначению("Просрочен").Представление = Представление;
	КонецЕсли;
	
	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, Элементы.ОтборЖелаемаяДата.СписокВыбора);
	ОбновитьОтображениеДанных();

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияЗаСегодняНажатие(Элемент) 
	
	ОчиститьОтбор();
	ОтборПериод = Новый СтандартныйПериод(ВариантСтандартногоПериода.Сегодня);
	УстановитьОтборПоПериоду(ЭтаФорма);

КонецПроцедуры

&НаСервере
Процедура ДекорацияНаМнеНажатиеСервер()
	
	ОтборОтветственный 	= Пользователи.АвторизованныйПользователь();
	ОтборСтатус			= Перечисления.СтатусыИнцидентов.Зарегистрирован;

КонецПроцедуры

&НаСервере
Процедура ДекорацияПросроченоНажатиеНаСервере()
	
	ДатаСобытия = ОбщегоНазначения.ТекущаяДатаПользователя();
	ОтборСтатус = Перечисления.СтатусыИнцидентов.Зарегистрирован;

КонецПроцедуры 

&НаКлиенте
Процедура ОчиститьОтбор()
	
	СтруктураОтбора = СтруктураОтбораИнцидентов();
	
	Для каждого Элемент Из СтруктураОтбора Цикл
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, Элемент.Ключ); 
	КонецЦикла;

	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, Истина);

	ОтборАвтор			= Неопределено;
	ОтборВидИнцидента	= Неопределено;
	ОтборКритичность	= Неопределено;
	ОтборОтветственный	= Неопределено;
	ОтборПериод			= Неопределено;
	ОтборСтатус			= Неопределено;
	
КонецПроцедуры

&НаКлиенте
Функция СтруктураОтбораИнцидентов()
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ГруппаНачало");
	СтруктураОтбора.Вставить("ГруппаОкончание");
	СтруктураОтбора.Вставить("ДатаРегистрации");
	СтруктураОтбора.Вставить("ВидИнцидента");
	СтруктураОтбора.Вставить("Критичность");
	СтруктураОтбора.Вставить("Исполнитель");
	СтруктураОтбора.Вставить("Статус");
	СтруктураОтбора.Вставить("Автор");
	
	Возврат СтруктураОтбора;
	
КонецФункции

#КонецОбласти

#КонецОбласти