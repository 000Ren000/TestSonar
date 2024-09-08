﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидимостьОтбора = Ложь;
	
	ПечатьЭтикетокИЦенниковБПОПереопределяемый.ПриОпределенииПереопределенияПодбораТоваров(ПереопределенаФормаПодбора);
	ПечатьЭтикетокИЦенниковБПОПереопределяемый.ПриОпределенииПереопределенияПодбораПоШтрихкоду(ПереопределенаФормаПоискаПоШтрихкоду);
	ПечатьЭтикетокИЦенниковБПОПереопределяемый.ПриОпределенииПереопределенияВыгрузкиВТСД(ПереопределенаФормаВыгрузкиВТСД);
	ПечатьЭтикетокИЦенниковБПОПереопределяемый.ПриОпределенииПереопределенияОтбора(ПереопределенаФормаОтбора);
	
	ЦеныНаДату = ТекущаяДатаСеанса();
	Если Не ЗначениеЗаполнено(Объект.РежимПечати) Тогда
		Объект.РежимПечати = "ПечатьЦенников";
	КонецЕсли;
	ЗагрузитьНастройкиОтбора();
	
	УстановитьВидимостьИДоступностьЭлементовФормы();
	УстановитьВидимостьЭлементовИКолонокТаблицы();
	
	ПечатьЭтикетокИЦенниковБПОПереопределяемый.ФормаПечатьЭтикетокИЦенниковПриСозданииНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ПодключаемоеОборудование
	ЭтотОбъект.ИспользоватьПодключаемоеОборудование = Истина;
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтотОбъект, "СканерШтрихкода, СчитывательМагнитныхКарт");
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтотОбъект);
	// Конец ПодключаемоеОборудование
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ИсходныеДанные = Данные;
		
		РазделительGS1 = ОбщегоНазначенияБПОКлиентСервер.РазделительGS1();
		ЭкранированныйСимволGS1 = ОбщегоНазначенияБПОКлиентСервер.ЭкранированныйСимволGS1();
		Данные = СтрЗаменить(Данные, РазделительGS1, ЭкранированныйСимволGS1);
		
		ОписаниеСобытия = Новый Структура();
		ОписаниеОшибки  = "";
		ОписаниеСобытия.Вставить("Источник", Источник);
		ОписаниеСобытия.Вставить("Событие",  Событие);
		ОписаниеСобытия.Вставить("Данные",   Данные);
		
		Результат = МенеджерОборудованияКлиент.ПолучитьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
		Если Результат = Неопределено Тогда 
			ТекстСообщения = НСтр("ru = 'При обработке внешнего события от устройства произошла ошибка:'")
			+ Символы.ПС + ОписаниеОшибки;
			ОбщегоНазначенияБПОКлиент.СообщитьПользователю(ТекстСообщения);
		Иначе
			Если Результат.Источник = "ПодключаемоеОборудование" Тогда
				Если Результат.ИмяСобытия = "ScanData" Тогда
					
					ДанныеОповещения = Результат.Параметр;
					ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПоискаПоШтрихкодуЭтикетокИЦенниковБПО", ЭтотОбъект);
					ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДанныеОповещения);
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВводДоступен() Тогда
		Если ИмяСобытия = "ЗаполнитьДанныеЭтикетокИЦенников" Тогда
			
			Для Каждого Товар Из Параметр Цикл
				
				НоваяСтрока = Объект.Товары.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Товар);
				
			КонецЦикла;
			
		ИначеЕсли ИмяСобытия = "ScanData" Тогда
			
			ДанныеОповещения = Параметр[0];
			ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПоискаПоШтрихкодуЭтикетокИЦенниковБПО", ЭтотОбъект);
			ВыполнитьОбработкуОповещения(ОписаниеОповещения, ДанныеОповещения);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВыбранПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	ТекущаяСтрока = ТекущиеДанные.НомерСтроки - 1;
	
	Если НЕ ТекущиеДанные.Выбран Тогда
		ТекущиеДанные.Выбран = Ложь;
	Иначе
		
		ТекущиеДанные.Выбран = Истина;
		
		Если НЕ ЗначениеЗаполнено(ТекущиеДанные.ШаблонЦенникаЭтикетки) Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Не выбран шаблон печати'");
			Сообщение.Поле = "Объект.Товары["+ТекущаяСтрока+"].ШаблонЦенникаЭтикетки";
			Сообщение.Сообщить();
			
			ТекущиеДанные.Выбран = Ложь;
			
		ИначеЕсли НЕ ЗначениеЗаполнено(ТекущиеДанные.Количество) Тогда
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Не задано количество ценников'");
			Сообщение.Поле = "Объект.Товары["+ТекущаяСтрока+"].Количество";
			Сообщение.Сообщить();
			
			ТекущиеДанные.Выбран = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыШаблонПечатиПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	ТекущиеДанные.Выбран = ПроверитьВозможностьВыбораТовара(ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	ВидЦеныПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПодобратьТовары(Команда)
	ПодобратьТоварыНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОтбору(Команда)
	
	Если Объект.Товары.Количество() = 0 Тогда
		ЗаполнитьПоОтборуНаКлиенте();
	Иначе
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗаполнитьТаблицуТоваров", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Сохранить данные о количестве, шаблонах в табличной части при перезаполнении?'"), РежимДиалогаВопрос.ДаНетОтмена,,КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ПараметрыОтбора = Новый Структура("Выбран", Истина);
	Товары = Объект.Товары.НайтиСтроки(ПараметрыОтбора);
	
	Если Товары.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не выбрано ни одного товара'"));
		Возврат;
	КонецЕсли;
	
	ПараметрыПечати = ПолучитьПараметрыПечати();
	
	// Вызов БСП
	Если Объект.ПечатьНаОбычномПринтере И ОбщегоНазначенияБПОКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.Печать") Тогда
		
		ПараметрКоманды = Новый Массив;
		ПараметрКоманды.Добавить(ПредопределенноеЗначение("Справочник.ШаблоныЭтикетокИЦенниковБПО.ПустаяСсылка"));
		
		МодульУправлениеПечатьюКлиент = ОбщегоНазначенияБПОКлиент.ОбщийМодуль("УправлениеПечатьюКлиент");
			МодульУправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Обработка.ПечатьЭтикетокИЦенниковБПО", "Ценники", ПараметрКоманды, ЭтотОбъект, ПараметрыПечати);
		
	Иначе
		
		ПоляДляЗаполнения = Новый Массив;
		ДанныеДляПринтераЭтикеток = ДанныеДляПринтераЭтикетокНаСервере(ПараметрыПечати, ПоляДляЗаполнения);
		
		Для Каждого Макет Из ДанныеДляПринтераЭтикеток Цикл
			
			ОписаниеОповещениеПриЗавершенииПечати = Новый ОписаниеОповещения("ОбработкаКомандыПечатиЦенниковИЭтикетокНаПринтереЭтикетокЗавершение", ЭтотОбъект);
			ПараметрыПечатиЭтикеток = ОборудованиеПринтерыЭтикетокКлиент.ПараметрыОперацииПечатиЭтикеток(Макет.XMLОписаниеМакета, Макет.ДанныеДляПечатиЭтикеток);
			ОборудованиеПринтерыЭтикетокКлиент.НачатьПечатьЭтикеток(ОписаниеОповещениеПриЗавершенииПечати, ЭтаФорма.УникальныйИдентификатор, Неопределено, ПараметрыПечатиЭтикеток);
			
		КонецЦикла;
		
	КонецЕсли;
	// Конец Вызов БСП
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьШаблонЦенников(Команда)
	
	ОбработчикОповещения = Новый ОписаниеОповещения("ОбработчикУстановкиШаблона", ЭтотОбъект);
	Режим = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	ОткрытьФорму("Справочник.ШаблоныЭтикетокИЦенниковБПО.ФормаВыбора", , ЭтаФорма,,,, ОбработчикОповещения, Режим);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьКоличествоЦенников(Команда)
	
	ВыбранноеЗначение = Неопределено;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеУстановитьКоличествоЦенников", ЭтотОбъект);
	ПоказатьВводЧисла(ОписаниеОповещения,ВыбранноеЗначение, НСтр("ru = 'Введите количество ценников/этикеток'"), 10, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПоШтрихкоду(Команда)
	
	Штрихкод = "";
	ТекстЗаголовка = НСтр("ru = 'Введите штрихкод'");
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеПоискаПоШтрихкодуЭтикетокИЦенниковБПО", ЭтотОбъект);
	
	ПоказатьВводСтроки(ОписаниеОповещения, Штрихкод, ТекстЗаголовка);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьВТСД(Команда)
	
	ДополнительныеПараметры = Неопределено;
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ПараметрыВыгрузкиИЗагрузкиВТСД(ДополнительныеПараметры);
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ВыгрузитьВТСД(ЭтотОбъект, ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзТСД(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОповещениеЗагрузкиИзТСДЭтикетокИЦенниковБПО", ЭтотОбъект);
	
	ДополнительныеПараметры = Неопределено;
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ПараметрыВыгрузкиИЗагрузкиВТСД(ДополнительныеПараметры);
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ЗагрузитьИзТСД(ЭтотОбъект, ДополнительныеПараметры, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура Отбор(Команда)
	
	ВидимостьОтбора = НЕ ВидимостьОтбора;
	
	Если ВидимостьОтбора Тогда
		Элементы.ГруппаОтбор.Видимость = Истина;
		Элементы.Отбор.Заголовок = НСтр("ru = 'Скрыть отбор'");
	Иначе
		Элементы.ГруппаОтбор.Видимость = Ложь;
		Элементы.Отбор.Заголовок = НСтр("ru = 'Показать отбор'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьШтрихкодНоменклатуры(Команда)
	
	Результат = Ложь;
	
	Если Не ЗначениеЗаполнено(Элементы.Товары.ВыделенныеСтроки) Тогда
		ОбщегоНазначенияБПОКлиент.СообщитьПользователю(НСтр("ru = 'В списке отсутствуют выделенные строки'"));
		Возврат;
	КонецЕсли;
	
	ВыделенныеТовары = Элементы.Товары.ВыделенныеСтроки;
	Штрихкоды = Новый Соответствие;
	ТЧТовары = Объект.Товары;
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.УстановитьШтрихкодыНоменклатуры(ВыделенныеТовары, ТЧТовары, Штрихкоды);
	
	Для Каждого ТекКлючИЗначение Из Штрихкоды Цикл
		СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(ТекКлючИЗначение.Ключ);
		СтрокаТЧ.Штрихкод = ТекКлючИЗначение.Значение;
	КонецЦикла
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементовФормы()
	
	Если Не ПереопределенаФормаПодбора Тогда
		
		Элементы.ПодобратьТовары.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ПереопределенаФормаПоискаПоШтрихкоду Тогда
		
		Элементы.ПоискПоШтрихкоду.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ПереопределенаФормаОтбора Тогда
		
		Элементы.Отбор.Видимость = Ложь;
		Элементы.ПодобратьТовары.Видимость = Ложь;
		
	КонецЕсли;
	
	Если Не ПереопределенаФормаВыгрузкиВТСД Тогда
		
		Элементы.ВыгрузитьВТСД.Видимость = Ложь;
		Элементы.ЗагрузитьИзТСД.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовИКолонокТаблицы()
	
	Если Не ЗначениеЗаполнено(Метаданные.ОпределяемыеТипы.ХарактеристикаБПО.Тип) Тогда
		Элементы.Товары["ТоварыХарактеристикаБПО"].Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Метаданные.ОпределяемыеТипы.УпаковкаБПО.Тип) Тогда
		Элементы.Товары["ТоварыУпаковкаБПО"].Видимость = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Метаданные.ОпределяемыеТипы.НоменклатураБПО.Тип) Тогда
		Элементы.Товары.Видимость = Ложь;
	КонецЕсли;

	Если Не ЗначениеЗаполнено(Метаданные.ОпределяемыеТипы.ТорговыйОбъектБПО.Тип) Тогда
		Элементы.ТорговыйОбъект.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОтборуНаКлиенте()
	
	МассивТоваровДляПечати = Новый Массив;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТорговыйОбъект", Объект.ТорговыйОбъектБПО);
	ПараметрыОткрытия.Вставить("ВидЦены", Объект.ВидЦены);
	ПараметрыОткрытия.Вставить("ВидЦеныАкционный", Объект.ВидЦеныАкционный);
	ПараметрыОткрытия.Вставить("КомпоновщикНастроек", КомпоновщикНастроек);
	ПараметрыОткрытия.Вставить("ЦеныНаДату", ЦеныНаДату);
	ПараметрыОткрытия.Вставить("РежимПечати", Объект.РежимПечати);
	
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ЗаполнитьПоОтбору(ПараметрыОткрытия, МассивТоваровДляПечати);
	
	Для Каждого Товар Из МассивТоваровДляПечати Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Товар);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТоварыНаКлиенте()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФормаВладелец", ЭтотОбъект);
	ПараметрыОткрытия.Вставить("ОбработчикЗакрытия", Новый ОписаниеОповещения("ПодобратьТоварыЗавершение", ЭтотОбъект, 
	Новый Структура("ТорговыйОбъектБПО, ВидЦены, ЦеныНаДату", Объект.ТорговыйОбъектБПО, Объект.ВидЦены, ЦеныНаДату)));
	ПараметрыОткрытия.Вставить("РежимБлокировки", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыОткрытия.Вставить("ТорговыйОбъект", Объект.ТорговыйОбъектБПО);
	ПараметрыОткрытия.Вставить("ВидЦены", Объект.ВидЦены);
	ПараметрыОткрытия.Вставить("ВидЦеныАкционный", Объект.ВидЦеныАкционный);
	ПараметрыОткрытия.Вставить("ЦеныНаДату", ЦеныНаДату);
	
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ОткрытьФормуПодбора(ПараметрыОткрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьТоварыЗавершение(Результат, ПараметрыОперации) Экспорт
	
	МассивТоваровДляПечати = Новый Массив;
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ПодобратьТоварыЗавершение(Результат, ПараметрыОперации, МассивТоваровДляПечати);
	
	Для Каждого Товар Из МассивТоваровДляПечати Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Товар);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеПоискаПоШтрихкодуЭтикетокИЦенниковБПО(Результат, ПараметрыОперации) Экспорт
	
	Если Не ПустаяСтрока(Результат) Тогда
		
		МассивТоваровДляПечати = Новый Массив;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТорговыйОбъект", Объект.ТорговыйОбъектБПО);
		ПараметрыОткрытия.Вставить("ВидЦены", Объект.ВидЦены);
		ПараметрыОткрытия.Вставить("ВидЦеныАкционный", Объект.ВидЦеныАкционный);
		ПараметрыОткрытия.Вставить("ЦеныНаДату", ЦеныНаДату);
		ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ОповещениеПоискаПоШтрихкодуЭтикетокИЦенниковБПО(Результат, ПараметрыОткрытия, МассивТоваровДляПечати);
		
		Для Каждого Товар Из МассивТоваровДляПечати Цикл
			
			НоваяСтрока = Объект.Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Товар);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗагрузкиИзТСДЭтикетокИЦенниковБПО(Результат, ПараметрыОперации) Экспорт
	
	МассивТоваровДляПечати = Новый Массив;
	ПечатьЭтикетокИЦенниковБПОКлиентПереопределяемый.ОповещениеЗагрузкиИзТСДЭтикетокИЦенниковБПО(Результат, ПараметрыОперации, МассивТоваровДляПечати);
	
	Для Каждого Товар Из МассивТоваровДляПечати Цикл
		
		НоваяСтрока = Объект.Товары.Добавить();
		НоваяСтрока.НоменклатураБПО   = Товар.НоменклатураБПО;
		НоваяСтрока.ХарактеристикаБПО = Товар.ХарактеристикаБПО;
		НоваяСтрока.УпаковкаБПО       = Товар.УпаковкаБПО;
		НоваяСтрока.Цена              = Товар.Цена;
		НоваяСтрока.ОрганизацияБПО    = Товар.ОрганизацияБПО;
		НоваяСтрока.Штрихкод          = Товар.Штрихкод;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикУстановкиШаблона(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		Количество = 0;
		МассивСтрок = Элементы.Товары.ВыделенныеСтроки;
		
		Для Каждого НомерСтроки Из МассивСтрок Цикл
			
			СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(НомерСтроки);
			СтрокаТЧ.ШаблонЦенникаЭтикетки = ВыбранноеЗначение;
			Если Не ЗначениеЗаполнено(СтрокаТЧ.Количество) Тогда
				СтрокаТЧ.Количество = 1;
			КонецЕсли;
			СтрокаТЧ.Выбран = Истина;
			
			Если СтрокаТЧ.Выбран Тогда
				Количество = Количество + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		КоличествоВсего = МассивСтрок.Количество();
		
		Текст = НСтр("ru = 'Установлен шаблон ""%Шаблон%"".'");
		Текст = СтрЗаменить(Текст, "%Шаблон%", ВыбранноеЗначение);
		
		ПоказатьОповещениеПользователюОВозможнойОшибке(Текст, Количество, КоличествоВсего);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеУстановитьКоличествоЦенников(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	
	Если НЕ ВыбранноеЗначение = Неопределено Тогда
		
		Количество = 0;
		
		МассивСтрок = Элементы.Товары.ВыделенныеСтроки;
		Для Каждого НомерСтроки Из МассивСтрок Цикл
			СтрокаТЧ = Объект.Товары.НайтиПоИдентификатору(НомерСтроки);
			СтрокаТЧ.Количество  = ВыбранноеЗначение;
			Если ЗначениеЗаполнено(СтрокаТЧ.ШаблонЦенникаЭтикетки) Тогда
				СтрокаТЧ.Выбран = Истина;
			КонецЕсли;
			
			Если СтрокаТЧ.Выбран Тогда
				Количество = Количество + 1;
			КонецЕсли;
			
		КонецЦикла;
		
		КоличествоВсего = МассивСтрок.Количество();
		
		Текст = НСтр("ru = 'Установлено количество ценников %Количество%.'");
		Текст = СтрЗаменить(Текст, "%Количество%", ВыбранноеЗначение);
		
		ПоказатьОповещениеПользователюОВозможнойОшибке(Текст, Количество, КоличествоВсего);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеЗаполнитьТаблицуТоваров(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Нет Тогда
		Объект.Товары.Очистить();
	КонецЕсли;
	
	ЗаполнитьПоОтборуНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОповещениеПользователюОВозможнойОшибке(Текст, Количество, КоличествоВсего)
	
	Если Количество < КоличествоВсего Тогда
		
		Текст = Текст
		        + ?(Текст <> "", Символы.ПС, "")
		        + НСтр("ru = 'Отметка выбора установлена для %КоличествоВыбранных% строк из %КоличествоВсего%.'");
	
		Текст = Текст
		        + Символы.ПС
		        + НСтр("ru = 'Проверьте, заполнены ли все обязательные реквизиты.'");
	
		Текст = СтрЗаменить(Текст, "%КоличествоВыбранных%", Количество);
		Текст = СтрЗаменить(Текст, "%КоличествоВсего%", КоличествоВсего);
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Операция выполнена'"), , Текст);
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДанныеДляПринтераЭтикетокНаСервере(ПараметрыПечати, ПоляДляЗаполнения)
	
	ШаблоныДляПечати = ПараметрыПечати.Товары.Выгрузить(Новый Структура("Выбран", Истина),"ШаблонЦенникаЭтикетки");
	ПоляДляЗаполнения = Обработки.ПечатьЭтикетокИЦенниковБПО.ПоляШаблонов(ШаблоныДляПечати);
	ДанныеНоменклатурыДляФормированияПечатныхФорм = ПечатьЭтикетокИЦенниковБПОПереопределяемый.ДанныеДляФормированияПечатныхФорм(ПараметрыПечати, ПоляДляЗаполнения, Неопределено);
	ДанныеЭтикеток = Обработки.ПечатьЭтикетокИЦенниковБПО.ДанныеДляПечатиЭтикеток(ДанныеНоменклатурыДляФормированияПечатныхФорм, ПоляДляЗаполнения);
	
	Возврат ДанныеЭтикеток;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаКомандыПечатиЦенниковИЭтикетокНаПринтереЭтикетокЗавершение(РезультатПечати, ДополнительныеПараметры) Экспорт
	
	Если НЕ РезультатПечати.Результат Тогда
		ПоказатьПредупреждение(, РезультатПечати.ОписаниеОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьНастройкиОтбора()
	
	СхемаКомпоновкиДанных = ПечатьЭтикетокИЦенниковБПОПереопределяемый.МакетСхемыКомпоновкиДанных();
	Если Не СхемаКомпоновкиДанных = Неопределено Тогда
		АдресСКД = ПоместитьВоВременноеХранилище(
						СхемаКомпоновкиДанных,
						ЭтаФорма.УникальныйИдентификатор);
		Источник = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСКД);
		КомпоновщикНастроек.Инициализировать(Источник);
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
		КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
		
		УдалитьНепроверяемыеОтборыКомпоновщика(КомпоновщикНастроек);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не определен макет компоновки данных.'");
		ОбщегоНазначенияБПО.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНепроверяемыеОтборыВГруппе(КоллекцияЭлементов, Компоновщик)
	
	Количество = КоллекцияЭлементов.Количество();
	
	Для Индекс = 1 По Количество Цикл
		
		ЭлементОтбора = КоллекцияЭлементов[Количество - Индекс];
		
		Если ТипЗнч(ЭлементОтбора)=Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
			
			Если Компоновщик.Настройки.Отбор.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
				КоллекцияЭлементов.Удалить(ЭлементОтбора);
			КонецЕсли;
			
		Иначе
			УдалитьНепроверяемыеОтборыВГруппе(ЭлементОтбора.Элементы, Компоновщик);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьНепроверяемыеОтборыКомпоновщика(Компоновщик)

	Количество = Компоновщик.Настройки.Отбор.Элементы.Количество();
	
	Для Индекс = 1 По Количество Цикл
		
		ЭлементОтбора = Компоновщик.Настройки.Отбор.Элементы[Количество - Индекс];
		
		Если ТипЗнч(ЭлементОтбора)=Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			
			ПолеОтбора = ЭлементОтбора.ЛевоеЗначение;
			
			Если Компоновщик.Настройки.Отбор.ДоступныеПоляОтбора.НайтиПоле(ПолеОтбора) = Неопределено Тогда
				Компоновщик.Настройки.Отбор.Элементы.Удалить(ЭлементОтбора);
			КонецЕсли;
			
		Иначе
			УдалитьНепроверяемыеОтборыВГруппе(ЭлементОтбора.Элементы, Компоновщик);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры

&НаСервере
Процедура ВидЦеныПриИзмененииСервер()

	ПечатьЭтикетокИЦенниковБПОПереопределяемый.ПриИзмененииВидаЦены(ЭтотОбъект);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПроверитьВозможностьВыбораТовара(ТекущиеДанные)
	
	Если (ТекущиеДанные.Количество = 0) Тогда
		
		Возврат Ложь;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(ТекущиеДанные.ШаблонЦенникаЭтикетки) Тогда
		
		Возврат Ложь;
		
	Иначе
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПолучитьПараметрыПечати()
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ТорговыйОбъект", Объект.ТорговыйОбъектБПО);
	Если Объект.ПечатьНаОбычномПринтере Тогда
		ПараметрыПечати.Вставить("Товары", ОбщегоНазначенияБПО.ТаблицаЗначенийВМассив(Объект.Товары.Выгрузить()));
	Иначе
		ПараметрыПечати.Вставить("Товары", Объект.Товары);
	КонецЕсли;
	ПараметрыПечати.Вставить("ВидЦены", Объект.ВидЦены);
	ПараметрыПечати.Вставить("ВидЦеныАкционный", Объект.ВидЦеныАкционный);
	ПараметрыПечати.Вставить("ЦеныНаДату", ЦеныНаДату);
	ПараметрыПечати.Вставить("КаждаяЭтикеткаНаНовомЛисте", Объект.КаждаяЭтикеткаНаНовомЛисте);
	
	Возврат ПараметрыПечати;

КонецФункции

#КонецОбласти