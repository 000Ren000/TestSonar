﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПоддерживаемыеТипыПодключаемогоОборудования = "СканерШтрихкода";
	ИнтеграцияИС.НастроитьПодключаемоеОборудование(ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "АлкогольнаяПродукция", АлкогольнаяПродукция, СтруктураБыстрогоОтбора);
	
	ШтрихкодированиеИС.ИнициализироватьКэшМаркируемойПродукции(ЭтотОбъект);
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, ПоддерживаемыеТипыПодключаемогоОборудования);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
	Если ИмяСобытия = "Запись_Справка2"
		И ТипЗнч(Параметр) = Тип("СправочникСсылка.Справки2ЕГАИС") Тогда
		Элементы.Список.ТекущаяСтрока = Параметр;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	ИнтеграцияЕГАИСКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(Список,
	                                                                       "АлкогольнаяПродукция",
	                                                                       АлкогольнаяПродукция,
	                                                                       СтруктураБыстрогоОтбора,
	                                                                       Настройки);

КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	СобытияФормИСКлиент.ВнешнееСобытиеПолученыШтрихкоды(
		"ПоискПоШтрихкодуЗавершение", ЭтотОбъект, Источник, Событие, Данные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АлкогольнаяПродукцияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
	                                                                        "АлкогольнаяПродукция",
	                                                                        АлкогольнаяПродукция,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(АлкогольнаяПродукция));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоискПоШтрихкодуВыполнить(Команда)
	
	ОчиститьСообщения();
	
	ШтрихкодированиеИСКлиент.ПоказатьВводШтрихкода(
		Новый ОписаниеОповещения("ОбработатьВводШтрихкода", ЭтотОбъект));
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОткрытьФормуУточненияДанных()
	
	ШтрихкодированиеИСКлиент.Подключаемый_ОткрытьФормуУточненияДанных(ЭтотОбъект,
		Новый ОписаниеОповещения("ОбработатьВводШтрихкода", ЭтотОбъект));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.АлкогольнаяПродукция.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Остаток.Имя);
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ДокументОснование.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.Ссылка.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Справки2ЕГАИС.ДляОприходованияИзлишков;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = '<не требуется>'"));
	
	//
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РегистрационныйНомер.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных(Элементы.Ссылка.ПутьКДанным);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.Справки2ЕГАИС.ДляОприходованияИзлишков;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", Новый Цвет);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст",      НСтр("ru = 'Для оприходования излишков'"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВводШтрихкода(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	ПараметрыСканирования = ШтрихкодированиеОбщегоНазначенияИСКлиент.ПараметрыСканирования(ЭтотОбъект);
	ПараметрыСканирования.ЗапрашиватьНоменклатуру = Ложь;
	
	ШтрихкодированиеОбщегоНазначенияИСКлиент.ОбработатьДанныеШтрихкода(
		"ПоискПоШтрихкодуЗавершение", ЭтотОбъект, ДанныеШтрихкода, ПараметрыСканирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкодуЗавершение(ДанныеШтрихкода, ДополнительныеПараметры) Экспорт
	
	Если ДанныеШтрихкода = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеШтрихкода.ТипШтрихкода = ПредопределенноеЗначение("Перечисление.ТипыШтрихкодов.DataMatrix") Тогда
		
		Если ЗначениеЗаполнено(ДанныеШтрихкода.Справка2) Тогда
			
			Элементы.Список.ТекущаяСтрока = ДанныеШтрихкода.Справка2;
			
		ИначеЕсли ДанныеШтрихкода.Справки2.Количество() > 0 Тогда
			
			СписокСсылок = Новый СписокЗначений;
			Для Каждого ДанныеСправки2 Из ДанныеШтрихкода.Справки2 Цикл
				СписокСсылок.Добавить(ДанныеСправки2.Справка2);
			КонецЦикла;
			
			ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Ссылка");
			
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
				Список,
				"Ссылка",
				СписокСсылок,
				ВидСравненияКомпоновкиДанных.ВСписке,,
				Истина,
				РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ);
				
		Иначе
			
			ОбщегоНазначенияКлиент.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'По штрихкоду %1 не удалось найти справку 2'"),
					ДанныеШтрихкода.Штрихкод));
			
		КонецЕсли;
		
	Иначе
		
			СтрШаблон(
				НСтр("ru = 'Штрихкод %1 не является кодом Data Matrix.
					       |Для проверки вхождения номера марки в диапазон отсканируйте штрихкод формата Data Matrix'"),
				ДанныеШтрихкода.Штрихкод);
		
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			СтрШаблон(
				НСтр("ru='Штрихкод %1 не является кодом Data Matrix.
					     |Для поиска справки 2 по диапазону считайте штрихкод ""Data Matrix"".'"), ДанныеШтрихкода.Штрихкод));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти