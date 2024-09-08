﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКассККМ") Тогда
		КассаККМ = Справочники.КассыККМ.КассаККМПоУмолчанию();
	КонецЕсли;
	
	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхВозвратахСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхВозвратахСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхВозвратахСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхВозвратахСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаКомандыСписка);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "ОтчетыОРозничныхВозвратах", "Дата");
	
	// ИнтеграцияГИСМ
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхВозвратах, "ЕстьМаркируемаяПродукцияГИСМ", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(ОтчетыОРозничныхВозвратах, "СтатусГИСМ", СтатусГИСМ, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(ОтчетыОРозничныхВозвратах, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(ОтчетыОРозничныхВозвратах, "Организация", Организация, СтруктураБыстрогоОтбора);

	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПриСозданииНаСервере(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	ИнтеграцияГИСМ.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.ДальнейшееДействиеГИСМОтбор.СписокВыбора,
		ИнтеграцияГИСМ.ВсеТребующиеДействияСтатусыИнформирования(), 
		ИнтеграцияГИСМ.ВсеТребующиеОжиданияСтатусыИнформирования());
	// Конец ИнтеграцияГИСМ

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

// Параметры:
// 	ИмяСобытия - Строка - 
// 	Параметр - Структура - содержит в том числе:
// 		* Ссылка - ДокументСсылка.ОтчетОРозничныхВозвратах - 
// 	Источник - Строка - 
// 
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			Данные = СобытияФормИСКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр);
			ОбработатьШтрихкоды(Данные);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	Если ИмяСобытия = "Запись_ОтчетОРозничныхВозвратах" Тогда
		
		Элементы.ОтчетыОРозничныхВозвратах.Обновить();
		
	КонецЕсли;
	
	// ИнтеграцияГИСМ
	Если ИмяСобытия = "#ГИСМ#ИзменениеСостоянияГИСМ"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ОтчетОРозничныхВозвратах") Тогда
		
		Элементы.ОтчетыОРозничныхВозвратах.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "#ГИСМ#ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусВФормахДокументов)) Тогда
		
		Элементы.ОтчетыОРозничныхВозвратах.Обновить();
		
	КонецЕсли;
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	КассаККМ = Настройки.Получить("КассаККМ");
	УстановитьОтборДинамическихСписков();
	
	ЗапрещеноДобавлятьНовыеДокументы = ЗапрещеноДобавлятьНовыеДокументы(КассаККМ);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхВозвратахСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхВозвратахСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхВозвратахСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхВозвратахСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	
	// ИнтеграцияГИСМ
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(ОтчетыОРозничныхВозвратах,
	                                                                     "СтатусГИСМ",
	                                                                     СтатусГИСМ,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПередЗагрузкойИзНастроек(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(ОтчетыОРозничныхВозвратах,
	                                                                     "Ответственный",
	                                                                     Ответственный,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(ОтчетыОРозничныхВозвратах,
	                                                                     "Организация",
	                                                                     Организация,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписковНаКлиенте();
	УстановитьДоступностьКнопокСозданияНовыхДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтчетыОРозничныхВозвратах

&НаКлиенте
Процедура ОтчетыОРозничныхВозвратахПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	Если Не(Не ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена) Тогда
		Отказ = Истина;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетыОРозничныхВозвратахПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.ОтчетыОРозничныхВозвратах);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.ОтчетыОРозничныхВозвратах, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.ОтчетыОРозничныхВозвратах);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.ОтчетыОРозничныхВозвратах);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаКлиенте
Процедура ОбработатьШтрихкоды(Данные)
	
	МассивСсылок = СсылкаНаЭлементСпискаПоШтрихкоду(Данные.Штрихкод);
	Если НЕ МассивСсылок.Количество() > 0 Тогда
		ШтрихкодированиеПечатныхФормКлиент.ОбъектНеНайден(Данные.Штрихкод);
	Иначе
		Элементы.ОтчетыОРозничныхВозвратах.ТекущаяСтрока = МассивСсылок[0];
		ПоказатьЗначение(Неопределено, МассивСсылок[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция СсылкаНаЭлементСпискаПоШтрихкоду(Штрихкод)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(ПредопределенноеЗначение("Документ.ОтчетОРозничныхВозвратах.ПустаяСсылка"));
	Возврат ШтрихкодированиеПечатныхФормКлиент.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Штрихкод, Менеджеры);
	
КонецФункции

#КонецОбласти

#Область Прочее

&НаСервереБезКонтекста
Функция ЗапрещеноДобавлятьНовыеДокументы(КассаККМ)
	
	Реквизиты = Справочники.КассыККМ.РеквизитыКассыККМ(КассаККМ);
	Возврат Реквизиты.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор
	    ИЛИ Реквизиты.ТипКассы = Перечисления.ТипыКассККМ.ККМOffline;
	
КонецФункции

// Так же вызывается ПриЗагрузкеДанныхИзНастроекНаСервере
&НаКлиенте
Процедура УстановитьДоступностьКнопокСозданияНовыхДокументов()
	
	ЗапрещеноДобавлятьНовыеДокументы = ЗапрещеноДобавлятьНовыеДокументы(КассаККМ);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхВозвратахСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтчетыОРозничныхВозвратахСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхВозвратахСоздать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "КонтекстноеМенюОтчетыОРозничныхВозвратахСкопировать", "Доступность", НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена);
	
КонецПроцедуры

// Процедура устанавливает отбор динамических списков формы.
//
&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхВозвратах, 
		"КассаККМ",
		КассаККМ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(КассаККМ));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхВозвратах,
		"СтатусГИСМ",
		СтатусГИСМ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(СтатусГИСМ));
	
КонецПроцедуры

// Процедура устанавливает отбор динамических списков формы.
//
&НаКлиенте
Процедура УстановитьОтборДинамическихСписковНаКлиенте()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхВозвратах, "КассаККМ", КассаККМ, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(КассаККМ));
	
КонецПроцедуры

// ИнтеграцияГИСМ
&НаКлиенте
Процедура СтатусГИСМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхВозвратах,
		"СтатусГИСМ",
		СтатусГИСМ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(СтатусГИСМ));
	
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеГИСМОтборПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ОтчетыОРозничныхВозвратах,
		"Ответственный",
		Ответственный,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Ответственный));
		
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхВозвратах,
	                                                                        "Организация",
	                                                                        Организация,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

// Конец ИнтеграцияГИСМ

&НаКлиенте
Процедура ОтчетыОРозничныхВозвратахВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ДальнейшееДействиеГИСМ Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
			Элементы.ОтчетыОРозничныхВозвратах,
			Элемент.ДанныеСтроки(ВыбраннаяСтрока).ДальнейшееДействиеГИСМ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.ОтчетыОРозничныхВозвратах,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Условное оформление динамического списка "СписокРаспоряженияНаОформление"
	СписокУсловноеОформление = ОтчетыОРозничныхВозвратах.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	// ИнтеграцияГИСМ
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусДальнейшееДействиеГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		Элементы.ДальнейшееДействиеГИСМ.Имя,
		"СтатусГИСМ",
		"ДальнейшееДействиеГИСМ");
		
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусИнформированияГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		"СтатусГИСМ");
	// Конец ИнтеграцияГИСМ

КонецПроцедуры


// ИнтеграцияГИСМ
#Область ОтборДальнейшиеДействия

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияГИСМ.УстановитьОтборПоДальнейшемуДействию(ОтчетыОРозничныхВозвратах,
	                                                    ДальнейшееДействиеГИСМ,
	                                                    ИнтеграцияГИСМ.ВсеТребующиеДействияСтатусыИнформирования(), 
	                                                    ИнтеграцияГИСМ.ВсеТребующиеОжиданияСтатусыИнформирования());
	
КонецПроцедуры

#КонецОбласти
// Конец ИнтеграцияГИСМ

#КонецОбласти

#КонецОбласти
