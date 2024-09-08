﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ВидНастройкиОбмена") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ВидНастройкиОбмена = Параметры.ВидНастройкиОбмена;
	Если Не ЗначениеЗаполнено(Параметры.ВидНастройкиОбмена) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	НастроитьФорму();
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ПараметрыНастройкиОбмена);
	
	Если ИспользоватьДнейЗагрузки3Знака(ВидНастройкиОбмена) Тогда
		ДнейЗагрузки3Знака = Параметры.ПараметрыНастройкиОбмена.ДнейЗагрузки;
		ДнейЗагрузки = 1;
	КонецЕсли;
	
	Если ДнейЗагрузки = 0 Тогда
		ДнейЗагрузки = 1;
	КонецЕсли;
	
	Если ДнейЗагрузки3Знака = 0 Тогда
		ДнейЗагрузки3Знака = 1;
	КонецЕсли;
	
	ЗаполнитьДоступныеВидыПродукции();
	ЗаполнитьДоступныеОперации();
	НастроитьЗависимыеОтВидаПродукцииЭлементыФормы(ЭтотОбъект);
	ОбновитьНадписьДнейЗагрузки(ЭтотОбъект);
	СтандартныеПодсистемыСервер.СброситьРазмерыИПоложениеОкна(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизиты.Очистить();
	
	Если ВидНастройкиОбмена = Перечисления.ВидыНастроекОбменаЗЕРНО.ЗагрузкаСДИЗ Тогда
		ПроверяемыеРеквизиты.Добавить("ВидПродукции");
	ИначеЕсли ВидНастройкиОбмена = Перечисления.ВидыНастроекОбменаЗЕРНО.ЗагрузкаПартий Тогда
		ПроверяемыеРеквизиты.Добавить("ВидПродукции");
		Если ВидПродукции = Перечисления.ВидыПродукцииИС.Зерно Тогда
			ПроверяемыеРеквизиты.Добавить("Операция");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбщегоНазначенияСобытияФормИСКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидПродукцииПриИзменении(Элемент)
	
	НастроитьЗависимыеОтВидаПродукцииЭлементыФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДнейЗагрузкиПриИзменении(Элемент)
	
	ОбновитьНадписьДнейЗагрузки(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДнейЗагрузки3ЗнакаПриИзменении(Элемент)
	
	ОбновитьНадписьДнейЗагрузки(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = ИнтеграцияЗЕРНОКлиентСервер.ИнициализироватьПараметрыНастройкиОбмена(ВидНастройкиОбмена);
	
	ЗаполнитьЗначенияСвойств(Результат, ЭтотОбъект);
	
	Если Результат.Свойство("ДнейЗагрузки")
		И ИспользоватьДнейЗагрузки3Знака(ВидНастройкиОбмена) Тогда
		Результат.ДнейЗагрузки = ДнейЗагрузки3Знака;
	КонецЕсли;
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьФорму()
	
	ИменаПараметров = Новый Массив;
	
	ПараметрыНастройкиОбмена = ИнтеграцияЗЕРНОКлиентСервер.ИнициализироватьПараметрыНастройкиОбмена(ВидНастройкиОбмена);
	Для Каждого ПараметрНастройкиОбмена Из ПараметрыНастройкиОбмена Цикл
		ИменаПараметров.Добавить(ПараметрНастройкиОбмена.Ключ);
	КонецЦикла;
	
	Для Каждого Элемент Из Элементы Цикл
		Если ТипЗнч(Элемент) = Тип("ПолеФормы") Тогда
			Элемент.Видимость = ИменаПараметров.Найти(Элемент.Имя) <> Неопределено;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.НадписьДнейЗагрузки.Видимость = Элементы.ДнейЗагрузки.Видимость;
	
	Если ИспользоватьДнейЗагрузки3Знака(ВидНастройкиОбмена) Тогда
		Элементы.ДнейЗагрузки.Видимость = Ложь;
		Элементы.ДнейЗагрузки3Знака.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеОтВидаПродукцииЭлементыФормы(Форма)

	Форма.Элементы.ТипОрганизации.Видимость =
		Форма.ВидНастройкиОбмена = ПредопределенноеЗначение("Перечисление.ВидыНастроекОбменаЗЕРНО.ЗагрузкаСДИЗ")
		И Форма.ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно");
	
	Форма.Элементы.Операция.Видимость =
		Форма.ВидНастройкиОбмена = ПредопределенноеЗначение("Перечисление.ВидыНастроекОбменаЗЕРНО.ЗагрузкаПартий")
		И Форма.ВидПродукции = ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Зерно");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеВидыПродукции()
	
	ВидыПродукции = ИнтеграцияЗЕРНОКлиентСерверПовтИсп.УчитываемыеВидыПродукции();
	
	Элементы.ВидПродукции.СписокВыбора.Очистить();
	Для Каждого УчитываемйВидПродукции Из ВидыПродукции Цикл
		Элементы.ВидПродукции.СписокВыбора.Добавить(УчитываемйВидПродукции, Строка(УчитываемйВидПродукции));
	КонецЦикла;
	Элементы.ВидПродукции.СписокВыбора.СортироватьПоПредставлению();
	
	Если Не ЗначениеЗаполнено(ВидПродукции) Тогда
		ВидПродукции = Элементы.ВидПродукции.СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеОперации()
	
	Элементы.Операция.СписокВыбора.Очистить();
	Элементы.Операция.СписокВыбора.Добавить(Перечисления.ВидыОперацийЗЕРНО.ЗапросПартий);
	Элементы.Операция.СписокВыбора.Добавить(Перечисления.ВидыОперацийЗЕРНО.ЗапросПартийНаХранении);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьНадписьДнейЗагрузки(Форма)
	
	Если ИспользоватьДнейЗагрузки3Знака(Форма.ВидНастройкиОбмена) Тогда
		ДнейЗагрузки = Форма.ДнейЗагрузки3Знака;
	Иначе
		ДнейЗагрузки = Форма.ДнейЗагрузки;
	КонецЕсли;
	
	Форма.Элементы.НадписьДнейЗагрузки.Заголовок = СтроковыеФункцииКлиентСервер.СтрокаСЧисломДляЛюбогоЯзыка(
		НСтр("ru = ';день;;дня;дней;дня'"),
		ДнейЗагрузки)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИспользоватьДнейЗагрузки3Знака(ВидНастройкиОбмена)
	
	Возврат ВидНастройкиОбмена = ПредопределенноеЗначение("Перечисление.ВидыНастроекОбменаЗЕРНО.ЗагрузкаМестФормированияПартий");
	
КонецФункции

#КонецОбласти
