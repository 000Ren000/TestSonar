﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПриСозданииЧтенииНаСервере();
	КонецЕсли;
	
	УстановитьПредставлениеВидовПродукции(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Объект.ВидыПродукции.Количество() = 0 Тогда
		ТекстСообщения = Нстр("ru = 'Не введено ни одной строки в список ""Виды продукции""'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, "ВидыПродукцииПредставление",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВидСервисПровайдераПриИзменении(Элемент)
	
	УстановитьСтранаТолькоРоссия(ЭтотОбъект);
	
	Россия = ПредопределенноеЗначение("Справочник.СтраныМира.Россия");
	
	Если СтранаТолькоРоссия И Объект.Страна <> Россия Тогда
		Объект.Страна = Россия;
	КонецЕсли;
	
	ОбновитьВидимостьДоступностьЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыПродукцииПредставлениеНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьФорму(
		"ОбщаяФорма.ФормаМножественногоВыбораИСМП",
		ПараметрыФормыВыбораВидовПродукции(),
		ЭтотОбъект, , , ,
		Новый ОписаниеОповещения("ВидыПродукцииЗавершениеВыбора", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПараметрыФормыВыбораВидовПродукции()
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Заголовок",         "");
	ПараметрыОткрытия.Вставить("ДоступныеЗначения", Новый СписокЗначений());
	ПараметрыОткрытия.Вставить("ВыбранныеЗначения", Новый СписокЗначений());
	
	Для Каждого СтрокаВидыПродукции Из Объект.ВидыПродукции Цикл
		ПараметрыОткрытия.ВыбранныеЗначения.Добавить(СтрокаВидыПродукции.ВидПродукции);
	КонецЦикла;
	
	Если Объект.Ссылка.Пустая() Тогда
		ПараметрыОткрытия.Заголовок = НСтр("ru = 'Сервис-провайдер СУЗ (создание) (виды продукции)'");
	Иначе
		ПараметрыОткрытия.Заголовок = СтрШаблон(
			НСтр("ru = '%1 (Сервис-провайдер СУЗ) (виды продукции)'"),
			Объект.Наименование);
	КонецЕсли;
	
	НедоступныеВидыПродукции = НедоступныеВидыПродукции();
	
	Для Каждого ВидПродукции Из ОбщегоНазначенияИСМПКлиентСерверПовтИсп.УчитываемыеВидыМаркируемойПродукции() Цикл
		
		Если ПараметрыОткрытия.ВыбранныеЗначения.НайтиПоЗначению(ВидПродукции) <> Неопределено
			Или НедоступныеВидыПродукции.Найти(ВидПродукции) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыОткрытия.ДоступныеЗначения.Добавить(ВидПродукции);
		
	КонецЦикла;
	
	Возврат ПараметрыОткрытия;
	
КонецФункции

#Область ПриИзмененииРеквизитов

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПредставлениеВидовПродукции(Форма)
	
	Объект = Форма.Объект;
	
	Форма.КоличествоВидовПродукции = Объект.ВидыПродукции.Количество();
	
	Если Форма.КоличествоВидовПродукции = 0 Тогда
		Форма.ВидыПродукцииПредставление = НСтр("ru = 'Выбрать'");
		Возврат ;
	КонецЕсли;
	
	Представление = "";
	ПредставлениеДлина = 0;
	МаксимальнаяДлина = 60;
	КоличествоДобавлено = 0;
	
	Разделитель = ", ";
	ТекстОкончанияСтроки = НСтр("ru = ' ( + еще %1 )'");
	
	Для Каждого СтрокаВидыПродукции Из Объект.ВидыПродукции Цикл
		
		ТекущееПредставление = Строка(СтрокаВидыПродукции.ВидПродукции);
		Если КоличествоДобавлено > 0 Тогда
			ТекущееПредставление = Разделитель + ТекущееПредставление;
		КонецЕсли;
			
		ПредставлениеДлина = ПредставлениеДлина + СтрДлина(ТекущееПредставление);
		
		Если Форма.КоличествоВидовПродукции = КоличествоДобавлено + 1 Тогда
			МаксимальнаяДлина = МаксимальнаяДлина + СтрДлина(ТекстОкончанияСтроки);
		КонецЕсли;
		
		Если ПредставлениеДлина > МаксимальнаяДлина И КоличествоДобавлено > 0 Тогда
			Представление = Представление + СтрШаблон(ТекстОкончанияСтроки, Форма.КоличествоВидовПродукции - КоличествоДобавлено);
			Прервать;
		КонецЕсли;
		
		Представление = Представление + ТекущееПредставление;
		
		КоличествоДобавлено = КоличествоДобавлено + 1;
		
	КонецЦикла;
	
	Форма.ВидыПродукцииПредставление = Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыПродукцииЗавершениеВыбора(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ВидыПродукции.Очистить();
	
	Для Каждого ЭлементВидПродукции Из Результат Цикл
		СтрокаВидыПродукции = Объект.ВидыПродукции.Добавить();
		СтрокаВидыПродукции.ВидПродукции = ЭлементВидПродукции.Значение;
	КонецЦикла;
	
	ЭтотОбъект.Модифицированность = Истина;
	
	УстановитьПредставлениеВидовПродукции(ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаКлиентеНаСервереБезКонтекста
Функция НедоступныеВидыПродукции()
	
	Результат = Новый Массив;
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.Табак"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.АльтернативныйТабак"));
	Результат.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.НикотиносодержащаяПродукция"));
	
	Возврат Результат;
	
КонецФункции
&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ВидыПродукцииПредставление.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("КоличествоВидовПродукции");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;
	
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаТребуетВниманияГосИС);

КонецПроцедуры

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()
	
	УправлениеПараметрамиВыбораРеквизитовФормы();
	
	УстановитьСтранаТолькоРоссия(ЭтотОбъект);
	
	ОбновитьВидимостьДоступностьЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УправлениеПараметрамиВыбораРеквизитовФормы()
	
	Массив = Новый Массив;
	
	Массив.Добавить(Новый ПараметрВыбора("Отбор.УчастникЕАЭС", Истина));
	Элементы.Страна.ПараметрыВыбора = Новый ФиксированныйМассив(Массив);
	
КонецПроцедуры	

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьДоступностьЭлементовФормы(Форма)
	
	Форма.Элементы.Страна.Доступность = Не Форма.СтранаТолькоРоссия;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьСтранаТолькоРоссия(Форма)
	
	Форма.СтранаТолькоРоссия = Форма.Объект.ВидСервисПровайдера = ПредопределенноеЗначение("Перечисление.ВидыСервисПровайдеровСУЗ.ЦЭМ")
		Или Форма.Объект.ВидСервисПровайдера = ПредопределенноеЗначение("Перечисление.ВидыСервисПровайдеровСУЗ.КомиссионнаяПлощадка");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
