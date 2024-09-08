﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЦветГиперссылки = ЦветаСтиля.ЦветГиперссылкиГосИС;
	
	ОбработатьПереданныеПараметры(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НастроитьЭлементыФормыПриСоздании();
	УстановитьЗаголовокФормы();
	
	ОбщегоНазначенияСобытияФормИСПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПартияСАТУРН"
		И ТипЗнч(Параметр) = Тип("СправочникСсылка.ПартииСАТУРН") Тогда
		
		Элементы.Список.Обновить();
		Элементы.Список.ТекущаяСтрока = Источник;
		
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагруженные;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтраницыФормыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если РежимВыбора Тогда
		
		Если ТекущаяСтраница = Элементы.СтраницаЗагруженные Тогда
			Элементы.СписокВыбрать.КнопкаПоУмолчанию = Истина;
		Иначе
			Элементы.ВыбратьИзКлассификатора.КнопкаПоУмолчанию = Истина;
		КонецЕсли;
	
	КонецЕсли;
	
	Если Не ПереключениеМеждуСтраницамиВыполнялось
		И РежимВыбора Тогда
		
		ОбработатьНайденныеПартии(1);
		
	КонецЕсли;
	
	ПереключениеМеждуСтраницамиВыполнялось = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПараметровПоискаВКлассификатореОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьФормуПараметрыПоиска" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ПараметрыПоиска", ПараметрыПоиска);
		
		ОткрытьФорму(
			"Справочник.ПартииСАТУРН.Форма.ПараметрыПоиска",
			ПараметрыОткрытия,
			ЭтотОбъект,,,,
			Новый ОписаниеОповещения("ОбработатьПараметрыПоискаВКлассификаторе", ЭтотОбъект));
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)	
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПриВыбореИзЗагруженных();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПартииСАТУРН 

&НаКлиенте
Процедура ПартииСАТУРНВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	ПриВыбореИзДанныхКлассификатора();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДанныеКлассификатора(Команда)
	
	ТекущиеДанные = Элементы.ПартииСАТУРН.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, ОбщегоНазначенияИСКлиентСервер.ТекстКомандаНеМожетБытьВыполнена());
		Возврат;
	КонецЕсли;
	
	ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.Идентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзКлассификатора(Команда)
	ПриВыбореИзДанныхКлассификатора();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИзЗагруженных(Команда)
	ПриВыбореИзЗагруженных();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ИнициализацияФормыИУправлениеЭлементами

&НаСервере
Процедура ОбработатьПереданныеПараметры(Отказ)
	
	РежимВыбора          = Параметры.РежимВыбора;
	
	Если ТипЗнч(Параметры.ПараметрыПоиска) = Тип("Структура") Тогда

		ПараметрыПоиска = Параметры.ПараметрыПоиска;
		ОбработатьНайденныеПартии(1);
	
	Иначе
		ПараметрыПоиска = Новый Структура;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЭлементыФормыПриСоздании()

	СформироватьПредставлениеПараметровПоиска(ПараметрыПоиска, Истина);
	
	Элементы.ПоискНеНастроен.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.Неактуальность;
	Элементы.ПоискНеНастроен.ОтображениеСостояния.Текст = НСтр("ru = 'Элементы классификатора не выведены. Настройте отбор и выполните поиск.'");
	Элементы.ПоискНеНастроен.ОтображениеСостояния.Видимость = Истина;
	
	Если РежимВыбора Тогда
		
		Элементы.СписокВыбрать.Видимость                = Истина;
		Элементы.СписокКонтекстноеМенюВыбрать.Видимость = Истина;
		
	Иначе
		
		Элементы.СписокВыбрать.Видимость                = Ложь;
		Элементы.СписокКонтекстноеМенюВыбрать.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокФормы()

	ТекстЗаголовка = "";
	
	Если РежимВыбора Тогда
		ТекстЗаголовка = НСтр("ru = 'Выбор партии САТУРН'");
	Иначе
		ТекстЗаголовка = НСтр("ru = 'Классификатор партий САТУРН'");
	КонецЕсли;
	
	Заголовок = ТекстЗаголовка;

КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Загруженные. Отображение неактивными элементы со статусами кроме Актуально
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Список.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыОбъектовСАТУРН.Актуально;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);
	
	// Классификатор. Отображение неактивными элементы со статусами кроме Актуально
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПартииСАТУРН.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПартииСАТУРН.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыОбъектовСАТУРН.Актуально;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветНедоступногоТекста);

КонецПроцедуры

#КонецОбласти

#Область Поиск

&НаКлиенте
Процедура ОбработатьПараметрыПоискаВКлассификаторе(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено
		Или Результат = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПоиска = Результат;
	ОбработатьНайденныеПартии(1);
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьНайденныеПартии(НомерСтраницы)
	
	ПартииСАТУРН.Очистить();
	
	Если ПараметрыПоиска.Свойство("Идентификатор") Тогда
		Результат = ИнтерфейсСАТУРНВызовСервера.ПартияПоИдентификатору(ПараметрыПоиска.Идентификатор);
		ДобавитьВСписокНайденнуюПартию(Результат);
	Иначе
		
		КоличествоЭлементовНаСтранице = 100;
		Результат = ИнтерфейсСАТУРНВызовСервера.СписокПартий(ПараметрыПоиска, НомерСтраницы, КоличествоЭлементовНаСтранице);
		ЗаполнитьСписокПартий(Результат, НомерСтраницы);
		
	КонецЕсли;
	
	СформироватьПредставлениеПараметровПоиска(ПараметрыПоиска);
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьСтрокуПартии(ДанныеПартии)
	
	ДанныеПартии = ИнтерфейсСАТУРН.ДанныеПартии(ДанныеПартии);
	
	НоваяСтрока = ПартииСАТУРН.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяСтрока, ДанныеПартии);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПартий(Результат, НомерСтраницы)
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Для Каждого СтрокаТЧ Из Результат.Список Цикл	
		ДобавитьСтрокуПартии(СтрокаТЧ);
	КонецЦикла;
	
	ОпределитьНаличиеПартииВИБ();
	
	ОбщееКоличество = Результат.Список.Количество();
	
	Если ОбщееКоличество >= 500 Тогда
		КоличествоСтраниц = 2;
	Иначе
		КоличествоСтраниц = 1;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВСписокНайденнуюПартию(Результат)
	
	Если ЗначениеЗаполнено(Результат.ТекстОшибки) Тогда
		ОбщегоНазначения.СообщитьПользователю(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Если Результат.Элемент <> Неопределено Тогда
		ДобавитьСтрокуПартии(Результат.Элемент);
	КонецЕсли;
	
	ОпределитьНаличиеПартииВИБ();
	
	КоличествоСтраниц = 1;

	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаПоискВКлассификаторе;
	
КонецПроцедуры

&НаСервере
Процедура ОпределитьНаличиеПартииВИБ()
	
	Если ПартииСАТУРН.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;

	ПараметрыОбмена = ИнтеграцияСАТУРН.ПараметрыОбмена();
	ИмяТаблицы      = Метаданные.Справочники.ПартииСАТУРН.ПолноеИмя();
	
	Для Каждого СтрокаТаблицы Из ПартииСАТУРН Цикл
		ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, СтрокаТаблицы.Идентификатор, Неопределено);
	КонецЦикла;
	
	ИнтеграцияСАТУРНСлужебный.СсылкиПоИдентификаторам(ПараметрыОбмена);
	
	Для Каждого СтрокаТаблицы Из ПартииСАТУРН Цикл
		
		НайденнаяСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, СтрокаТаблицы.Идентификатор);
		Если ЗначениеЗаполнено(НайденнаяСсылка) Тогда
			
			СтрокаТаблицы.ИндексКартинкиЕстьВБазе = 1;
			СтрокаТаблицы.Партия                  = НайденнаяСсылка;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ПредставлениеОтбора

&НаСервере
Процедура СформироватьПредставлениеПараметровПоиска(ПараметрыОтбора, ПриСоздании = Ложь)
	
	СтрокаОтбор = "";
	
	КоличествоПараметровОтбора = 0;
	
	Если ПараметрыОтбора <> Неопределено Тогда
		
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'GUID'"),         "GUID",           КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Идентификатор'"), "Идентификатор", КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Наименование'"),  "Наименование",  КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'ПАТ'"),           "ПАТ",           КоличествоПараметровОтбора);
		ДобавитьВПредставление(СтрокаОтбор, ПараметрыОтбора, НСтр("ru = 'Статус'"),        "Статус",        КоличествоПараметровОтбора);

	КонецЕсли;
	
	Если КоличествоПараметровОтбора = 0 Тогда	
		ПредставлениеОтбора = ПредставлениеПустогоОтбора(ЭтотОбъект, ПриСоздании);	
	Иначе	
		ПредставлениеОтбора = ПредставлениеНеПустогоОтбора(СтрокаОтбор, ЭтотОбъект, ПриСоздании);	
	КонецЕсли;
	
	КоличествоСтраницНесколько = КоличествоСтраниц > 1;
	НулевойРезультат           = ПартииСАТУРН.Количество() = 0;
	
	Элементы.ГруппаИнформацияОНеКорректномЗапросе.Видимость = КоличествоСтраницНесколько И Не НулевойРезультат;
	
	Если ПриСоздании Или КоличествоСтраницНесколько И НулевойРезультат Тогда
		
		Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость = Истина;
		Элементы.ВыбратьИзКлассификатора.Видимость           = Ложь;
		
		Элементы.СтраницыПартииСАТУРН.ТекущаяСтраница = Элементы.СтраницаПартииСАТУРНПоискНеВыполнен;
		
		Если КоличествоСтраницНесколько Тогда
			Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость = Ложь;
			Элементы.ПоискНеНастроен.ОтображениеСостояния.Текст  =
				НСтр("ru = 'Заданные условия поиска дали слишком много результатов. Уточните реквизиты отбора и выполните поиск.'");
		КонецЕсли;
		
	Иначе
		
		Элементы.КартинкаИнформацияНеНастроенПоиск.Видимость                            = Ложь;
		Элементы.ВыбратьИзКлассификатора.Видимость                                      = РежимВыбора;
		Элементы.ПартииСАТУРНКонтекстноеМенюВыбратьИзКлассификатора.Видимость = РежимВыбора;
		
		Элементы.СтраницыПартииСАТУРН.ТекущаяСтраница = Элементы.СтраницаПартииСАТУРНЭлементы;
		
	КонецЕсли;
	
	ПредставлениеПараметровПоиска = ПредставлениеОтбора;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВПредставление(Представление, ПараметрыОтбора, ПредставлениеПоля, ИмяПоля, КоличествоПараметров)
	
	Если ПараметрыОтбора.Свойство(ИмяПоля) Тогда
		Значение = ПараметрыОтбора[ИмяПоля];
		КоличествоПараметров = КоличествоПараметров + 1;
	Иначе
		Значение = Неопределено;	
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Значение) Тогда
		Возврат;
	КонецЕсли;
	
	Если ИмяПоля = "Наименование" Тогда
		Разделитель = " " + НСтр("ru = 'содержит'") + " ";	
	Иначе
		Разделитель = " = ";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Представление) Тогда
		Представление = Представление + " " + НСтр("ru = 'и'") + " " + ПредставлениеПоля + Разделитель + """" + Значение + """";
	Иначе
		Представление = ПредставлениеПоля + Разделитель + """" + Значение + """";
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеПустогоОтбора(Форма, ПриСоздании = Ложь)
	
	Если ПриСоздании Тогда
		
		Строки = Новый Массив;
		Строки.Добавить(НСтр("ru = 'Для вывода партий САТУРН'"));
		Строки.Добавить(" ");
		Строки.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'настройте отбор'"),,
				Форма.ЦветГиперссылки,,
				"ОткрытьФормуПараметрыПоиска"));
		Строки.Добавить(" ");
		Строки.Добавить(НСтр("ru = 'и выполните поиск'"));
		
	Иначе

		СтрокаПредставлениеОтбора = НСтр("ru = 'Отбор не настроен'");

		МассивСтрокИзменить = Новый Массив;
	
		МассивСтрокИзменить.Добавить(" (");
		МассивСтрокИзменить.Добавить(
			Новый ФорматированнаяСтрока(
				НСтр("ru = 'настроить отбор'"),,
				Форма.ЦветГиперссылки,,
				"ОткрытьФормуПараметрыПоиска"));
		МассивСтрокИзменить.Добавить(")");
	
		Строки = Новый Массив;
		Строки.Добавить(СтрокаПредставлениеОтбора);
		Строки.Добавить(Новый ФорматированнаяСтрока(МассивСтрокИзменить));
	
	КонецЕсли;
	
	Возврат Новый ФорматированнаяСтрока(Строки);

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеНеПустогоОтбора(СтрокаОтбор, Форма, ПриСоздании = Ложь)
	
	СтрокаПредставлениеОтбора = СтрШаблон(НСтр("ru = 'Установлен отбор по %1'"), СтрокаОтбор);
	
	МассивСтрокИзменить = Новый Массив;
	
	МассивСтрокИзменить.Добавить(" (");
	МассивСтрокИзменить.Добавить(
		Новый ФорматированнаяСтрока(
			НСтр("ru = 'изменить'"),,
			Форма.ЦветГиперссылки,,
			"ОткрытьФормуПараметрыПоиска"));
	МассивСтрокИзменить.Добавить(")");
	
	Строки = Новый Массив;
	Строки.Добавить(СтрокаПредставлениеОтбора);
	Строки.Добавить(Новый ФорматированнаяСтрока(МассивСтрокИзменить));
	
	Возврат Новый ФорматированнаяСтрока(Строки);
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ПартияПослеСоздания(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора
		И ЗначениеЗаполнено(Результат)
		И ТипЗнч(Результат) = Тип("СправочникСсылка.ПартииСАТУРН") Тогда
		
		ОповеститьОВыборе(Результат);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуДанныхКлассификатора(Идентификатор)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Идентификатор", Идентификатор); 
	
	ОповещениеОЗакрытииФормыДанныхКлассификатора = Новый ОписаниеОповещения("ДанныеКлассификатораПослеЗакрытия", ЭтотОбъект);
	ОткрытьФорму(
		"Справочник.ПартииСАТУРН.Форма.ДанныеКлассификатора",
		ПараметрыФормы, ЭтотОбъект,,,,
		ОповещениеОЗакрытииФормыДанныхКлассификатора, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДанныеКлассификатораПослеЗакрытия(Результат, ДополнительныеПараметры) Экспорт

	Если ЗначениеЗаполнено(Результат)
		И ТипЗнч(Результат) = Тип("СправочникСсылка.ПартииСАТУРН") Тогда
		
		Если РежимВыбора Тогда
			ОповеститьОВыборе(Результат);
		Иначе
			
			ОпределитьНаличиеПартииВИБ();
			Элементы.Список.ТекущаяСтрока = Результат;
			Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаЗагруженные;
			
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореИзДанныхКлассификатора()

	ТекущиеДанные = Элементы.ПартииСАТУРН.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		
		Если ЗначениеЗаполнено(ТекущиеДанные.Партия) Тогда
			ОповеститьОВыборе(ТекущиеДанные.Партия);
		Иначе
			ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.Идентификатор);
		КонецЕсли;
		
	Иначе
		ОткрытьФормуДанныхКлассификатора(ТекущиеДанные.Идентификатор);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриВыбореИзЗагруженных()
	
	ОчиститьСообщения();
	
	Если Не ИнтеграцияИСКлиент.ВыборСтрокиСпискаКорректен(Элементы.Список, Истина, Ложь) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Команда не может быть выполнена для указанного объекта'"));
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если РежимВыбора Тогда
		ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти