﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ТипОбъектаДО", ТипОбъектаДО);
	Параметры.Свойство("ТипОбъектаИС", ТипОбъектаИС);
	Параметры.Свойство("ВидДокументаДО", ВидДокументаДО);
	Параметры.Свойство("Вариант", Вариант);
	Параметры.Свойство("ПредставлениеРеквизитаОбъектаИС", ПредставлениеРеквизитаОбъектаИС);
	Параметры.Свойство("ИмяРеквизитаОбъектаДО", ИмяРеквизитаОбъектаДО);
	Параметры.Свойство("ИмяРеквизитаОбъектаИС", ИмяРеквизитаОбъектаИС);
	Параметры.Свойство("ПредставлениеРеквизитаОбъектаДО", ПредставлениеРеквизитаОбъектаДО);
	Параметры.Свойство("ВычисляемоеВыражение", ВычисляемоеВыражение);
	Параметры.Свойство("МестоВыполненияВыражения", МестоВыполненияВыражения);
	Параметры.Свойство("РеквизитыОбъектаДО", РеквизитыОбъектаДО);
	Параметры.Свойство("Обновлять", Обновлять);
	Параметры.Свойство("РежимИзмененияДанныхПроведенногоДокумента", РежимИзмененияДанныхПроведенногоДокумента);
	Если Не ЗначениеЗаполнено(РежимИзмененияДанныхПроведенногоДокумента) Тогда
		РежимИзмененияДанныхПроведенногоДокумента =
			Перечисления.РежимИзмененияПроведенногоДокументаДанными1СДокументооборота.Запрещено;
	КонецЕсли;
	
	Если Параметры.Свойство("Подсказка") И ЗначениеЗаполнено(Параметры.Подсказка) Тогда
		Элементы.ПредставлениеРеквизитаОбъектаИС.Подсказка = Параметры.Подсказка;
		Элементы.ПредставлениеРеквизитаОбъектаИС.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
	КонецЕсли;
	
	РеквизитОбъекта = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта");
	ВыражениеНаВстроенномЯзыке =
		ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке");
	РеквизитТаблицы = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.РеквизитТаблицы");
	НеЗаполнять = ПредопределенноеЗначение("Перечисление.ВариантыПравилЗаполненияРеквизитов.ПустаяСсылка");
	
	// Выберем вариант по умолчанию.
	НетТаблиц = Истина;
	Для Каждого РеквизитОбъектаДО Из РеквизитыОбъектаДО Цикл // см. ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.ДанныеРеквизита
		Если РеквизитОбъектаДО.ЭтоТаблица Тогда
			НетТаблиц = Ложь;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если НетТаблиц Тогда
		Элементы.ГруппаИзРеквизита.Видимость = Ложь;
		Элементы.ОбновлятьГруппаИзВыражения.Видимость = Истина;
		Элементы.Вариант.СписокВыбора.Удалить(0);
	КонецЕсли;
	
	СокращенноеНаименованиеКонфигурации =
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.СокращенноеНаименованиеКонфигурации();
	Если ЗначениеЗаполнено(СокращенноеНаименованиеКонфигурации) Тогда
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Правило заполнения таблицы %1'"), СокращенноеНаименованиеКонфигурации);
	КонецЕсли;
	
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.Видимость = Параметры.ЗаполняетсяДокумент;
	
	// Установим доступные режимы изменения в проведенном документе.
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.СписокВыбора.Добавить(
		Перечисления.РежимИзмененияПроведенногоДокументаДанными1СДокументооборота.РазрешеноСПерепроведением);
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.СписокВыбора.Добавить(
		Перечисления.РежимИзмененияПроведенногоДокументаДанными1СДокументооборота.РазрешеноБезПерепроведения);
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.СписокВыбора.Добавить(
		Перечисления.РежимИзмененияПроведенногоДокументаДанными1СДокументооборота.Запрещено);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьПереопределяемый.УстановитьРежимыИзмененияВПроведенномДокументе(
		ТипОбъектаИС,
		ПредставлениеРеквизитаОбъектаИС,
		Элементы.РежимИзмененияДанныхПроведенногоДокумента.СписокВыбора);
	
	Элементы.Обновлять.Видимость =
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ДоступенФункционалВерсииСервиса("1.3.2.3.CORP");
	
	Если МестоВыполненияВыражения = Перечисления.МестаВыполненияВыраженийНаВстроенномЯзыке.НаСторонеДО Тогда
		Элементы.ВычисляемоеВыражение.Подсказка =
			НСтр("ru = 'Выражение будет выполняться в базе 1С:Документооборот'");
	Иначе
		Элементы.ВычисляемоеВыражение.Подсказка =
			СтрШаблон(НСтр("ru = 'Выражение будет выполняться в базе %1'"), СокращенноеНаименованиеКонфигурации);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантПриИзменении(Элемент)
	
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеРеквизитаОбъектаДОНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыбратьРеквизитОбъектаДокументооборота();
	
КонецПроцедуры

&НаКлиенте
Процедура ВычисляемоеВыражениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ВыбратьВычисляемоеВыражение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяРеквизитаОбъектаДО");
	Результат.Вставить("ПредставлениеРеквизитаОбъектаДО");
	Результат.Вставить("Пояснение");
	Результат.Вставить("ВычисляемоеВыражение");
	Результат.Вставить("МестоВыполненияВыражения");
	Результат.Вставить("Картинка");
	Результат.Вставить("Обновлять", Обновлять);
	
	Если Вариант = РеквизитОбъекта Тогда
		Результат.ИмяРеквизитаОбъектаДО = ИмяРеквизитаОбъектаДО;
		Результат.ПредставлениеРеквизитаОбъектаДО = ПредставлениеРеквизитаОбъектаДО;
		Результат.Картинка = 1;
		
	ИначеЕсли Вариант = РеквизитТаблицы Тогда
		
		Результат.Пояснение = НСтр("ru = 'Заполняется по правилам для отдельных реквизитов таблицы'");
		Результат.Картинка = 1;
		
	ИначеЕсли Вариант = ВыражениеНаВстроенномЯзыке Тогда
		Результат.ВычисляемоеВыражение = ВычисляемоеВыражение;
		Результат.МестоВыполненияВыражения = ?(ЗначениеЗаполнено(МестоВыполненияВыражения),
			МестоВыполненияВыражения,
			ПредопределенноеЗначение("Перечисление.МестаВыполненияВыраженийНаВстроенномЯзыке.НаСторонеИС"));
		Результат.Картинка = 3;
		
	КонецЕсли;
	
	Результат.Вставить("Вариант", Вариант);
	Результат.Вставить("РежимИзмененияДанныхПроведенногоДокумента", РежимИзмененияДанныхПроведенногоДокумента);
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаДокументооборота()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипОбъектаДО", ТипОбъектаДО);
	ПараметрыФормы.Вставить("РеквизитыОбъектаДО", РеквизитыОбъектаДО);
	ПараметрыФормы.Вставить("ИмяРеквизитаОбъектаДО", ИмяРеквизитаОбъектаДО);
	ПараметрыФормы.Вставить("ПредставлениеРеквизитаОбъектаИС", ПредставлениеРеквизитаОбъектаИС);
	ПараметрыФормы.Вставить("ЭтоТаблица", Истина);
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьРеквизитОбъектаДокументооборотаЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.ВыборРеквизитаДокументооборота",
		ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьРеквизитОбъектаДокументооборотаЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Результат.Свойство("Имя", ИмяРеквизитаОбъектаДО);
		Результат.Свойство("Представление", ПредставлениеРеквизитаОбъектаДО);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражение()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВычисляемоеВыражение", ВычисляемоеВыражение);
	ПараметрыФормы.Вставить("МестоВыполненияВыражения", МестоВыполненияВыражения);
	ПараметрыФормы.Вставить("ТипОбъектаДО", ТипОбъектаДО);
	ПараметрыФормы.Вставить("ТипОбъектаИС", ТипОбъектаИС);
	ПараметрыФормы.Вставить("ИмяРеквизитаОбъектаИС", ИмяРеквизитаОбъектаИС);
	ПараметрыФормы.Вставить("ЭтоТаблица", Истина);
	ПараметрыФормы.Вставить("ВидДокументаДО", ВидДокументаДО);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьВычисляемоеВыражениеЗавершение", ЭтотОбъект);
	
	ОткрытьФорму(
		"Справочник.ПравилаИнтеграцииС1СДокументооборотом3.Форма.ВыражениеНаВстроенномЯзыке",
		ПараметрыФормы,
		ЭтотОбъект,,,,
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьВычисляемоеВыражениеЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ВычисляемоеВыражение = Результат.ВычисляемоеВыражение;
		МестоВыполненияВыражения = Результат.МестоВыполненияВыражения;
		
		Если МестоВыполненияВыражения =
				ПредопределенноеЗначение("Перечисление.МестаВыполненияВыраженийНаВстроенномЯзыке.НаСторонеДО") Тогда
			Элементы.ВычисляемоеВыражение.Подсказка =
				НСтр("ru = 'Выражение будет выполняться в базе 1С:Документооборот'");
		Иначе
			Элементы.ВычисляемоеВыражение.Подсказка =
				СтрШаблон(НСтр("ru = 'Выражение будет выполняться в базе %1'"), СокращенноеНаименованиеКонфигурации);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступность()
	
	Элементы.ПредставлениеРеквизитаОбъектаДО.Доступность = (Вариант = РеквизитОбъекта);
	Элементы.ПредставлениеРеквизитаОбъектаДО.АвтоОтметкаНезаполненного =
		(Вариант = РеквизитОбъекта);
	Элементы.ПредставлениеРеквизитаОбъектаДО.ОтметкаНезаполненного =
		(Вариант = РеквизитОбъекта) И Не ЗначениеЗаполнено(ПредставлениеРеквизитаОбъектаДО);
	
	Элементы.ВычисляемоеВыражение.Доступность = (Вариант = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.АвтоОтметкаНезаполненного = (Вариант = ВыражениеНаВстроенномЯзыке);
	Элементы.ВычисляемоеВыражение.ОтметкаНезаполненного =
		(Вариант = ВыражениеНаВстроенномЯзыке) И Не ЗначениеЗаполнено(ВычисляемоеВыражение);
	
	Элементы.РежимИзмененияДанныхПроведенногоДокумента.Доступность = (Вариант <> НеЗаполнять);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.РеквизитОбъекта Тогда 
		ПроверяемыеРеквизиты.Добавить("ПредставлениеРеквизитаОбъектаДО");
		Если Параметры.ЗаполняетсяДокумент Тогда
			ПроверяемыеРеквизиты.Добавить("РежимИзмененияДанныхПроведенногоДокумента");
		КонецЕсли;
		
	ИначеЕсли Вариант = Перечисления.ВариантыПравилЗаполненияРеквизитов.ВыражениеНаВстроенномЯзыке Тогда 
		ПроверяемыеРеквизиты.Добавить("ВычисляемоеВыражение");
		Если Параметры.ЗаполняетсяДокумент Тогда
			ПроверяемыеРеквизиты.Добавить("РежимИзмененияДанныхПроведенногоДокумента");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти