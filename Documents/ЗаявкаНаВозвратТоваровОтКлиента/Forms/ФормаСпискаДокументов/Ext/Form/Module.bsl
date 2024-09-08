﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ЗаголовокФормы) Тогда
		Заголовок = Параметры.ЗаголовокФормы;
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	ИспользоватьУпрощеннуюСхемуОплаты = ПолучитьФункциональнуюОпцию("ИспользоватьУпрощеннуюСхемуОплатыВПродажах");
	
	Список.Параметры.УстановитьЗначениеПараметра("ДатаАктуальности",               НачалоДня(ТекущаяДатаСеанса()));
	ИспользоватьОрдернуюСхемуПриОтгрузке = ПолучитьФункциональнуюОпцию("ИспользоватьОрдернуюСхемуПриОтгрузке");
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ОтборыСписковКлиентСервер.ЗаполнитьСписокВыбораОтбораПоАктуальности(Элементы.ОтборСрокВыполнения.СписокВыбора);	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Приоритет", Приоритет, СтруктураБыстрогоОтбора);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриСозданииНаСервере(Список, Актуальность, Элементы.ОтборСрокВыполнения.СписокВыбора, ДатаСобытия, СтруктураБыстрогоОтбора);
	
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриСозданииНаСервере(Состояние, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоСостояниюСервер();
	КонецЕсли;
	
	ЗаполнитьСписокХозяйственныхОпераций();
	ЗаполнитьСписокВыбораОтбораПоСостояниюСервер(Элементы.ОтборСостояние.СписокВыбора, ИспользоватьУпрощеннуюСхемуОплаты);
	ИспользоватьРеализациюПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьРеализациюПоНесколькимЗаказам");
	ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам = ПолучитьФункциональнуюОпцию("ИспользоватьАктыВыполненныхРаботПоНесколькимЗаказам");
	
	УстановитьВидимостьЭлементов();
	ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента = ПолучитьФункциональнуюОпцию("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	Если НЕ ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента Тогда
		Элементы.СписокУстановитьСтатусКВыполнению.Заголовок = НСтр("ru='В резерве'");
	КонецЕсли;
	
	ДобавлениеДоступно = ПравоДоступа("Добавление", Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента);
	ИспользоватьКомиссиюПриПродажах = ПолучитьФункциональнуюОпцию("ИспользоватьКомиссиюПриПродажах");
	ИспользоватьРозничныеПродажи = ПолучитьФункциональнуюОпцию("ИспользоватьРозничныеПродажи");
	
	Элементы.ГруппаСоздать.Видимость = ДобавлениеДоступно И (ИспользоватьКомиссиюПриПродажах ИЛИ ИспользоватьРозничныеПродажи);
	Если ДобавлениеДоступно Тогда
		Элементы.СписокСоздать.Видимость = НЕ ИспользоватьКомиссиюПриПродажах И НЕ ИспользоватьРозничныеПродажи;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(Новый ОписаниеОповещения("ОбработкаОповещенияЗавершение", ЭтотОбъект, Новый Структура("ИмяСобытия", ИмяСобытия)), МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
            Возврат;
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	ОбработкаОповещенияФрагмент(ИмяСобытия);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ИмяСобытия = ДополнительныеПараметры.ИмяСобытия;
    
    
    ОбработкаОповещенияФрагмент(ИмяСобытия);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещенияФрагмент(Знач ИмяСобытия)
    
	Если ИмяСобытия = "ЗачтенаОплата" 
		ИЛИ ПродажиКлиент.ИзменилисьДокументыОплатыКлиентам(ИмяСобытия) 
		ИЛИ ИмяСобытия = "ЗакрытиеЗаказов" Тогда
        Элементы.Список.Обновить();
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Менеджер", Менеджер, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список, "Приоритет", Приоритет, СтруктураБыстрогоОтбора, Настройки);
	ОтборыСписковКлиентСервер.ОтборПоАктуальностиПриЗагрузкеИзНастроек(Список, Актуальность, Элементы.ОтборСрокВыполнения.СписокВыбора, ДатаСобытия, СтруктураБыстрогоОтбора, Настройки);
	
	Если ОтборыСписковКлиентСервер.НеобходимОтборПоСостояниюПриЗагрузкеИзНастроек(Состояние, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоСостояниюСервер();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	УстановитьОтборПоСостояниюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияПриИзменении(Элемент)
	
	ОтборыСписковКлиентСервер.ПриИзмененииОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, Элементы.ОтборСрокВыполнения.СписокВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.ПриВыбореОтбораПоАктуальности(
		ВыбранноеЗначение, 
		СтандартнаяОбработка, 
		ЭтаФорма,
		Список, 
		"Актуальность",
		"ОтборСрокВыполнения",
		"ДатаСобытия");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСрокВыполненияОчистка(Элемент, СтандартнаяОбработка)
	
	ОтборыСписковКлиентСервер.ПриОчисткеОтбораПоАктуальности(Список, Актуальность, ДатаСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Менеджер", Менеджер, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Менеджер));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПриоритетПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Приоритет", Приоритет, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Приоритет));
	
КонецПроцедуры

&НаКлиенте
Процедура МенеджерОчистка(Элемент, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Менеджер) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборПриоритетОчистка(Элемент, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Приоритет) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеОчистка(Элемент, СтандартнаяОбработка)
	Если Состояние = Неопределено Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СписокПроцентОтгрузки" Или Поле.Имя = "СписокСостояние" Тогда
		
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если Не ТекущиеДанные = Неопределено Тогда
			
			СтандартнаяОбработка = Ложь;
			СписокДокументов = Новый СписокЗначений;
			СписокДокументов.Добавить(ТекущиеДанные.Ссылка);
			
			ОткрытьФорму("Отчет.СостояниеВыполненияДокументов.Форма.ФормаОтчета", 
			             Новый Структура("ВходящиеДокументы", СписокДокументов), 
			             ЭтаФорма,
			             Ложь);
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ОбеспечениеВДокументахКлиент.СписокПриИзменении(ЭтотОбъект, "Документ.ЗаявкаНаВозвратТоваровОтКлиента");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСтатусНаСогласовании(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""На согласовании"". 
		|По принятым к выполнению заявкам могут быть оформлены документы. Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНаСогласованииЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНаСогласованииЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "НеСогласована");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='На согласовании'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВозврату(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""К возврату"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВозвратуЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВозвратуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "КВозврату");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='К возврату'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнению(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	Если ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента Тогда
		ИмяСтатуса = НСтр("ru='К выполнению'");
	Иначе
		ИмяСтатуса = НСтр("ru='В резерве'");
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""%ИмяСтатуса%"". Продолжить?'");
	ТекстВопроса = СтрЗаменить(ТекстВопроса, "%ИмяСтатуса%", ИмяСтатуса);
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКВыполнениюЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки, ИмяСтатуса", ВыделенныеСтроки, ИмяСтатуса)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКВыполнениюЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    ИмяСтатуса = ДополнительныеПараметры.ИмяСтатуса;
    
    
    Ответ = РезультатВопроса;
    
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "КОбеспечению");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), ИмяСтатуса);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОтгрузке(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""К отгрузке"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусКОтгрузкеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусКОтгрузкеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "КОтгрузке");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='К отгрузке'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтклонена(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке заявок будет установлен статус ""Отклонена"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусОтклоненаЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтклоненаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Отклонена");
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Отклонена'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусВыполнена(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗакрытия = Новый Структура;
	СписокЗаказов = Новый СписокЗначений;
	СписокЗаказов.ЗагрузитьЗначения(ВыделенныеСтроки);
	СтруктураЗакрытия.Вставить("Заказы",                       СписокЗаказов);
	СтруктураЗакрытия.Вставить("ОтменитьНеотработанныеСтроки", Истина);
	СтруктураЗакрытия.Вставить("ЗакрыватьЗаказы",              Истина);
	
	ОткрытьФорму("Обработка.ПомощникЗакрытияЗаказов.Форма.ФормаЗакрытия", СтруктураЗакрытия,
					ЭтаФорма,,,, Неопределено, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуНаВозвратОтКомиссионера(Команда)
	
	СоздатьЗаявкуНаВозвратТоваровОтКлиента(0);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуНаВозвратОтРозничногоПокупателя(Команда)
	
	СоздатьЗаявкуНаВозвратТоваровОтКлиента(1);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуНаВозвратОтХранителя(Команда)
	
	СоздатьЗаявкуНаВозвратТоваровОтКлиента(2);
	
КонецПроцедуры

&НаКлиенте
// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	// Условное оформление динамического списка "Список"
	СписокУсловноеОформление = Список.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	// Документ имеет высокий приоритет
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Документ имеет высокий приоритет'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Приоритеты.ПолучитьВысшийПриоритет();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии;
	ОтборЭлемента.ПравоеЗначение = Новый СписокЗначений;
	ОтборЭлемента.ПравоеЗначение.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.СостоянияЗаявокНаВозвратТоваровОтКлиентов");
	ОтборЭлемента.ПравоеЗначение.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Выполнена);
	ОтборЭлемента.ПравоеЗначение.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Отклонена);

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ВысокийПриоритетДокумента);
	
	// Документ имеет низкий приоритет
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Документ имеет низкий приоритет'");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Приоритет");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Приоритеты.ПолучитьНизшийПриоритет();
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПометкаУдаления");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии;
	ОтборЭлемента.ПравоеЗначение = Новый СписокЗначений;
	ОтборЭлемента.ПравоеЗначение.ТипЗначения = Новый ОписаниеТипов("ПеречислениеСсылка.СостоянияЗаявокНаВозвратТоваровОтКлиентов");
	ОтборЭлемента.ПравоеЗначение.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Выполнена);
	ОтборЭлемента.ПравоеЗначение.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Отклонена);

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.НизкийПриоритетДокумента);
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента") Тогда
	
		// Выделение цветом состояния "Выполнена"
		Элемент = СписокУсловноеОформление.Элементы.Добавить();
		Элемент.Представление = НСтр("ru = 'Выделение цветом состояния ""Выполнена""'");
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Выполнена;
		
		// Скрытие состояния и итоги по заявкам, созданных в режиме "Заказ как счет"
		Элемент = СписокУсловноеОформление.Элементы.Добавить();
		Элемент.Представление = НСтр("ru = 'Скрытие состояния и итогов по заявкам, созданных в режиме ""Заказ как счет""'");
		
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("Состояние");
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДолгКлиента");
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("НашДолг");
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентДолга");
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентОплаты");
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СуммаОплаты");
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СуммаОтгрузки");
		Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентОтгрузки");
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЭтоЗаказКакСчет");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '-'"));
		
	КонецЕсли;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);
	
	// Выделение цветом просроченной заявки
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом просроченной заявки'");
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("Состояние");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДатаСобытия");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Просрочен");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныйДокумент);
	
	// Выделение цветом состояния "Отклонена"
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Выделение цветом состояния ""Отклонена""'");
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("Состояние");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Отклонена;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЗакрытыйДокумент);
	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(ШрифтыСтиля.ОбычныйШрифтТекста,,,,,,Истина));
	
	// Скрытие итогов по заявке при учете расчетов по договорам
	Элемент = СписокУсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Скрытие итогов по заявке при учете расчетов по договорам'");
	
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СуммаОплаты");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СуммаПросроченнойОплаты");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("НашДолг");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентДолга");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентОплаты");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ДолгКлиента");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("ПроцентОтгрузки");
	Элемент.Поля.Элементы.Добавить().Поле = Новый ПолеКомпоновкиДанных("СуммаОтгрузки");
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПорядокРасчетов");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ПорядокРасчетов.ПоЗаказам;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Серый);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '-'"));

	УсловноеОформление.Элементы.Очистить();
	
	// Изменение представления статуса, в зависимости от включенных опций.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Изменение представления статуса, в зависимости от включенных опций.'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСтатус.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОбеспечению;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'К выполнению'"));

	// Изменение представления статуса, в зависимости от включенных опций.
	Элемент = УсловноеОформление.Элементы.Добавить();
	Элемент.Представление = НСтр("ru = 'Изменение представления статуса, в зависимости от включенных опций.'");
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокСтатус.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыЗаявокНаВозвратТоваровОтКлиентов.КОбеспечению;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'В резерве'"));
	

	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);

	
КонецПроцедуры

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ЗаявкаНаВозвратТоваровОтКлиента.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

&НаКлиенте
Процедура ОбработатьШтрихкоды(Знач Оповещение, Данные)
	
	Если Не ШтрихкодированиеНоменклатурыКлиент.ШтрихкодыВалидны(Данные) Тогда
		Возврат;
	КонецЕсли;
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если МассивСсылок.Количество() > 0 Тогда
		Ссылка = МассивСсылок[0];
		Элементы.Список.ТекущаяСтрока = Ссылка;
		ПоказатьЗначение(Новый ОписаниеОповещения("ОбработатьШтрихкодыЗавершение", ЭтотОбъект, Новый Структура("Данные, Оповещение", Данные, Оповещение)), МассивСсылок[0]);
        Возврат;
	Иначе
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	КонецЕсли;
	
	ОбработатьШтрихкодыФрагмент(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодыЗавершение(ДополнительныеПараметры) Экспорт
    
    Данные = ДополнительныеПараметры.Данные;
    Оповещение = ДополнительныеПараметры.Оповещение;
    
    
    ОбработатьШтрихкодыФрагмент(Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШтрихкодыФрагмент(Знач Оповещение)
    
    ВыполнитьОбработкуОповещения(Оповещение);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗаданияРаспределенияЗапасовПоЗаказам()
	ОбеспечениеВДокументахКлиент.ПроверитьВыполнениеЗаданияРаспределенияЗапасовПоЗаказам(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокХозяйственныхОпераций()
	
	СписокХозяйственныхОпераций.Очистить();
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтКомиссионера);
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтРозничногоПокупателя);
	СписокХозяйственныхОпераций.Добавить(Перечисления.ХозяйственныеОперации.ВозвратОтХранителя);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьЗаявкуНаВозвратТоваровОтКлиента(ХозяйственнаяОперацияИндекс)

	ХозяйственнаяОперация = СписокХозяйственныхОпераций[ХозяйственнаяОперацияИндекс].Значение;

	СтруктураПараметры = Новый Структура;
	СтруктураПараметры.Вставить("Основание", Новый Структура("ХозяйственнаяОперация", ХозяйственнаяОперация));
	ОткрытьФорму("Документ.ЗаявкаНаВозвратТоваровОтКлиента.ФормаОбъекта", СтруктураПараметры, Элементы.Список);

КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьСписокВыбораОтбораПоСостояниюСервер(СписокВыбора, ИспользоватьУпрощеннуюСхемуОплаты)
	
	СписокВыбора.Добавить("ВсеОткрытые", НСтр("ru='Все открытые'"));
	СписокВыбора.Добавить("ВсеОжидающиеОплаты", НСтр("ru='Все ожидающие оплаты'"));
	СписокВыбора.Добавить("ВсеОжидающиеИсполнения", НСтр("ru='Все ожидающие исполнения'"));
	
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяСогласование);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ГотоваКВозврату);
	Если НЕ ИспользоватьУпрощеннуюСхемуОплаты Тогда
		СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяАвансИлиВозвратДоОбеспечения);
	КонецЕсли;
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ГотоваКОбеспечению);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяПредоплатаИлиВозвратДоОтгрузки);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяОбеспечение);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ГотоваКОтгрузке);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ВПроцессеОтгрузки);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяОплатаИлиВозвратПослеОтгрузки);
	Если ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыКлиентовБезПолнойОплаты") 
		ИЛИ ПолучитьФункциональнуюОпцию("НеЗакрыватьЗаказыКлиентовБезПолнойОтгрузки") Тогда
		СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяВыполнение);
	КонецЕсли;
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Выполнена);
	СписокВыбора.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Отклонена);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПоСостояниюСервер()
	
	Если Состояние = "ВсеОткрытые" Тогда
		
		МассивСостояний = Новый Массив();
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Выполнена);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.Отклонена);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", МассивСостояний, ВидСравненияКомпоновкиДанных.НеВСписке,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,, Истина);
		
	ИначеЕсли Состояние = "ВсеОжидающиеОплаты" Тогда
		
		МассивСостояний = Новый Массив();
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяАвансИлиВозвратДоОбеспечения);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяПредоплатаИлиВозвратДоОтгрузки);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяОплатаИлиВозвратПослеОтгрузки);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", МассивСостояний, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,, Истина);
		
	ИначеЕсли Состояние = "ВсеОжидающиеИсполнения" Тогда
		
		МассивСостояний = Новый Массив();
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяСогласование);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ГотоваКОбеспечению);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяОбеспечение);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ГотоваКОтгрузке);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ВПроцессеОтгрузки);
		МассивСостояний.Добавить(Перечисления.СостоянияЗаявокНаВозвратТоваровОтКлиентов.ОжидаетсяВыполнение);
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", МассивСостояний, ВидСравненияКомпоновкиДанных.ВСписке,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления", Ложь,,, Истина);
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Состояние", Состояние, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Состояние));
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПометкаУдаления",,,, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементов()
	
	ЕстьДоступНаИзменение = ПравоДоступа("Изменение", Метаданные.Документы.ЗаявкаНаВозвратТоваровОтКлиента);
	ИспользоватьРасширенныеВозможностиЗаказаКлиента = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента");
	ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента = ПолучитьФункциональнуюОпцию("ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента");
	Элементы.СписокУстановитьСтатусКОтгрузке.Видимость = ПолучитьФункциональнуюОпцию("ИспользоватьРасширенныеВозможностиЗаказаКлиента")
													И НЕ ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента;
	
	Элементы.СписокСуммаОплаты.Видимость             = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокПроцентОплаты.Видимость           = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокСуммаОтгрузки.Видимость           = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокПроцентОтгрузки.Видимость         = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокНашДолг.Видимость                 = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокДолгКлиента.Видимость             = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокПроцентДолга.Видимость            = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.ОтборДатаСобытия.Видимость              = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.СписокСостояние.Видимость               = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	Элементы.ЕстьРасхожденияОрдерНакладная.Видимость = ИспользоватьРасширенныеВозможностиЗаказаКлиента;
	
	КомандыОбеспеченияВидимы = ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента И ЕстьДоступНаИзменение;
	Элементы.СписокОтгрузитьЗаказ.Видимость = КомандыОбеспеченияВидимы;
	Элементы.СписокРезервироватьЗаказ.Видимость = КомандыОбеспеченияВидимы;
	Элементы.СписокРезервироватьПоМереПоступленияЗаказ.Видимость = КомандыОбеспеченияВидимы;
	Элементы.СписокКОбеспечениюЗаказ.Видимость = КомандыОбеспеченияВидимы;
	Элементы.СписокНеОбеспечиватьЗаказ.Видимость = КомандыОбеспеченияВидимы;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы,
		"СписокСостояниеОбеспеченияСпискаЗаказов",
		"Видимость",
		ИспользоватьПострочнуюОтгрузкуВЗаказеКлиента);
	
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаЖурналПродажиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("КлючНазначенияФормы", "");
	ПараметрыФормы.Вставить("УникальныйИдентификаторФормы", Ложь);

	ИмяОткрываемойФормы = "Обработка.ЖурналДокументовПродажи.Форма.СписокДокументов";
	//++ Локализация
	ИнтеграцияСМаркетплейсамиКлиент.ДополнитьПараметрыФормы(ПараметрыФормы,
		Список.КомпоновщикНастроек.Настройки.ДополнительныеСвойства, ИмяОткрываемойФормы);
	//-- Локализация
	
	ОткрытьФорму(ИмяОткрываемойФормы, ПараметрыФормы,, ПараметрыФормы.УникальныйИдентификаторФормы);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти
