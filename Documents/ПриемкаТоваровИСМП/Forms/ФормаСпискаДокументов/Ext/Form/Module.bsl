﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ВерсионированиеОбъектов") Тогда
		МодульВерсионированиеОбъектов = ОбщегоНазначения.ОбщийМодуль("ВерсионированиеОбъектов");
		МодульВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Настройки = ИнтеграцияИС.НастройкиФормыСпискаДокументов();
	Настройки.ТипыКОформлению     = Метаданные.ОпределяемыеТипы.ДокументыИСМППоддерживающиеСтатусыОформления;
	Настройки.ТипыКОбмену         = Метаданные.ОпределяемыеТипы.ДокументыИСМП;
	Настройки.КОформлению         = "";
	Настройки.ЭлементыКОформлению = "";

	УстановитьБыстрыйОтборСервер();
	СобытияФормИСМП.ПриСозданииНаСервереФормыСпискаДокументов(ЭтотОбъект, Настройки);

	ИнтеграцияИСМП.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.СтраницаОформленоОтборДальнейшееДействие.СписокВыбора, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
	НастроитьВидимостьДоступностьЭлементовСервер();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
	ИнтеграцияИС.УстановитьПризнакПравоИзмененияФормыСписка(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИнтеграцияИСКлиент.ОбработкаОповещенияВФормеСпискаДокументовИС(
		ЭтотОбъект,
		ИнтеграцияИСМПКлиентСервер.ИмяПодсистемы(),
		ИмяСобытия,
		Параметр,
		Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницаОформленоОтборСтатусПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "СтатусИСМП", Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборДальнейшееДействиеПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницаОформленоОтборОтветственныйПриИзменении(Элемент)
	
	ОтветственныйОтборПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОткрытьФормуВыбораОрганизаций(ЭтотОбъект, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииПриИзменении(Элемент)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организации, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияПриИзменении(Элемент)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Организация, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, Неопределено, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОформленоОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ИнтеграцияИСМПКлиент.ОбработатьВыборОрганизаций(ЭтотОбъект, ВыбранноеЗначение, Истина, "Оформлено");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияИСМПКлиент.ВыполнитьОбмен(
		ЭтотОбъект,
		ИнтеграцияИСМПКлиент.ОрганизацииДляОбмена(ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура АрхивироватьДокументы(Команда)
	
	ИнтеграцияИСКлиент.АрхивироватьДокументы(ЭтотОбъект, Элементы.Список, ИнтеграцияИСМПКлиент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьПоступление(Команда)
	
	ИнтеграцияИСМПКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюИСМП.ПодтвердитеПоступление"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтклонитьПоступление(Команда)
	
	ИнтеграцияИСМПКлиент.ПодготовитьСообщенияКПередаче(
		Элементы.Список,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюИСМП.ОтменитеОперацию"));
	
КонецПроцедуры

#Область ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормИСКлиентПереопределяемый.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Ошибки
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусИСМП.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.СтатусИСМП.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокСтатусов = Новый СписокЗначений;
	СписокСтатусов.ЗагрузитьЗначения(Документы.ПриемкаТоваровИСМП.СтатусыОшибок());
	ОтборЭлемента.ПравоеЗначение = СписокСтатусов;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиОшибкаПередачиГосИС);
	
	// Требуется ожидание
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СтатусИСМП.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.ДальнейшееДействиеИСМП.ПутьКДанным);
	ОтборЭлемента.ВидСравнения  = ВидСравненияКомпоновкиДанных.ВСписке;
	
	СписокДействий = Новый СписокЗначений;
	СписокДействий.ЗагрузитьЗначения(Документы.ПриемкаТоваровИСМП.ВсеТребующиеОжидания()); 
	ОтборЭлемента.ПравоеЗначение = СписокДействий;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.СтатусОбработкиПередаетсяГосИС);
	
	// Даты
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.Дата.Имя);
	
	// Сопоставить контрагента
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Контрагент.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(Элементы.Контрагент.ПутьКДанным);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблемаГосИС);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не сопоставлено>'"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", ложь);
	
КонецПроцедуры

#Область ОтборДальнейшиеДействия

// Возвращает массив дальнейших действий с документом, требующих участия пользователя
// 
// Возвращаемое значение:
// 	Массив - См. ПриемкаТоваровИСМП.ВсеТребующиеДействия - массив дальшейних действий
//
&НаСервереБезКонтекста
Функция ВсеТребующиеДействия()
	
	Возврат Документы.ПриемкаТоваровИСМП.ВсеТребующиеДействия();
	
КонецФункции

&НаСервереБезКонтекста
Функция ВсеТребующиеОжидания()
	
	Возврат Документы.ПриемкаТоваровИСМП.ВсеТребующиеОжидания();
	
КонецФункции

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияИСМП.УстановитьОтборПоДальнейшемуДействию(
		Список, ДальнейшееДействие, ВсеТребующиеДействия(), ВсеТребующиеОжидания());
	
КонецПроцедуры

&НаСервере
Процедура УстановитьБыстрыйОтборСервер()
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	Если СтруктураБыстрогоОтбора <> Неопределено Тогда
		
		СтруктураБыстрогоОтбора.Свойство("Организация", Организация);
		СтруктураБыстрогоОтбора.Свойство("Организации", Организации);
		
		Если ЗначениеЗаполнено(Организации) Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организации,,, Истина);
			ОрганизацииПредставление = Строка(Организации);
		КонецЕсли;
		
		ИнтеграцияИС.ОтборПоЗначениюСпискаПриСозданииНаСервере(Список, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
		
	КонецЕсли;
	
	ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам();
	
	Если ИнтеграцияИСМП.НеобходимОтборПоДальнейшемуДействиюПриСозданииНаСервере(ДальнейшееДействие, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьВидимостьДоступностьЭлементовСервер()
	
	УчитываемыеВидыМаркируемойПродукции = ОбщегоНазначенияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции();
	Элементы.ВидПродукции.Видимость = УчитываемыеВидыМаркируемойПродукции.Количество() > 1;
	
	Если Не ПравоДоступа("Добавление", Метаданные.Документы.ПриемкаТоваровИСМП) Тогда
		Элементы.ЗагрузитьВходящиеДокументы.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьОбменОбработкаОжидания()

	ИнтеграцияИСМПСлужебныйКлиент.ПродолжитьВыполнениеОбмена(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам()
	
	СобытияФормИСМП.ЗаполнитьСписокВыбораОрганизацииПоСохраненнымНастройкам(ЭтотОбъект, "Оформлено");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ответственный", Ответственный, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Ответственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВходящиеДокументы(Команда)
	
	ПараметрыОткрытия    = Новый Структура;
	ОрганизацииДляОбмена = Новый Массив;
	
	ОрганизацииИСМПДляОбмена = ИнтеграцияИСМПКлиент.ОрганизацииДляОбмена(ЭтотОбъект);
	
	Если ОрганизацииИСМПДляОбмена <> Неопределено Тогда
		Если ТипЗнч(ОрганизацииИСМПДляОбмена) = Тип("Массив") Тогда
			ОрганизацииДляОбмена = ОрганизацииИСМПДляОбмена;
		Иначе
			ОрганизацииДляОбмена.Добавить(ОрганизацииИСМПДляОбмена);
		КонецЕсли;
		ПараметрыОткрытия.Вставить("Организации", ОрганизацииДляОбмена);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	
	ОписаниеОповещенияПриЗакрытии = Новый ОписаниеОповещения("ОбработатьВыборПараметровЗагрузкиВходящихДокументов", 
		ЭтотОбъект,
		ДополнительныеПараметры);
		
	ОткрытьФорму(
		"Документ.ПриемкаТоваровИСМП.Форма.ЗагрузкаВходящихДокументов",
		ПараметрыОткрытия,
		ЭтотОбъект,,,,
		ОписаниеОповещенияПриЗакрытии, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьВыборПараметровЗагрузкиВходящихДокументов(ПараметрыЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(ПараметрыЗагрузки) Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСМПКлиент.ЗагрузитьВходящиеДокументы(
		ЭтотОбъект,
		ПараметрыЗагрузки);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти