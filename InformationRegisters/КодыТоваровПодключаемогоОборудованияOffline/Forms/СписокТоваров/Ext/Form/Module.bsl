﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Отбор = "Измененные";
	
	Устройство             = Параметры.Устройство;
	
	ПараметрыУстройства = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьПараметрыУстройства(Устройство);
	
	ТипОборудования        = ПараметрыУстройства.ТипОборудования;
	УзелИнформационнойБазы = ПараметрыУстройства.УзелИнформационнойБазы;
	МаксимальныйКод        = ПараметрыУстройства.МаксимальныйКод;
	
	ПравилоОбмена          = Параметры.ПравилоОбмена;
	
	ИспользоватьСерииНоменклатуры = ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатурыСклад", Новый Структура("Склад", ПараметрыУстройства.Склад));
	Если ИспользоватьСерииНоменклатуры Тогда
		Элементы.ТоварыТекстТребуетсяУказаниеСерий.Видимость = Истина;
	КонецЕсли;
	
	ПодключаемоеОборудованиеOfflineВызовСервера.ОбновитьКодыТоваров(ПравилоОбмена);
	
	ОтборПриИзмененииНаСервере();
	
	Если Не ЗначениеЗаполнено(УзелИнформационнойБазы) Тогда
		Элементы.ТоварыЗарегистрироватьИзменения.Видимость                = Ложь;
		Элементы.ТоварыКонтекстноеМенюЗарегистрироватьИзменения.Видимость = Ложь;
	КонецЕсли;
	
	Элементы.ТоварыНапечататьЦенникиДляВыделенныхСтрок.Видимость = ПравоДоступа("Просмотр", Метаданные.Обработки.ПечатьЭтикетокИЦенников);
	
	Заголовок = "Товары" + " " + НСтр("ru = 'для'") + " " + Устройство;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	
	Состояние(НСтр("ru = 'Выполняется обновление таблицы товаров...'"));
	
	ОтборПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбраннаяСтрока = Товары.НайтиПоИдентификатору(ВыбраннаяСтрока);
	Если ВыбраннаяСтрока <> Неопределено Тогда
		ПоказатьЗначение(Неопределено, ВыбраннаяСтрока.Номенклатура);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗарегистрироватьИзменения(Команда)
	
	ОписаниеОшибки = "";
	МассивКодов = Новый Массив;
	МассивСтрок = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		НайденнаяСтрока = Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		МассивСтрок.Добавить(НайденнаяСтрока);
		МассивКодов.Добавить(НайденнаяСтрока.Код);
	КонецЦикла;
	
	Если МассивКодов.Количество() > 0 Тогда
		Результат = ЗарегистрироватьИзмененияНаСервере(МассивКодов);
		Если Результат Тогда
			Для Каждого СтрокаТЧ Из МассивСтрок Цикл
				СтрокаТЧ.ИндексКартинкиЕстьИзменения = 1;
			КонецЦикла;
			Оповестить("Запись_КодыТоваровПодключаемогоОборудования", Новый Структура, Неопределено);
		Иначе
			ПоказатьПредупреждение(
				Неопределено, 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В процессе регистрации изменений произошла ошибка: %1'"),
					ОписаниеОшибки));
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Не выбраны строки для регистрации изменений'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыОчистить(Команда)
	
	Устройства = Новый Массив;
	Устройства.Добавить(Устройство);
	
	//++ Локализация
	Если ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыОфлайнОборудования.ККМ") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбменВыполнен", ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьОчисткуПрайсЛистаНаККМ(Устройство, УникальныйИдентификатор, ОписаниеОповещения);
	КонецЕсли;
	//-- Локализация
	
	Если ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток") Тогда
		ПодключаемоеОборудованиеOfflineКлиент.ОчиститьТоварыВВесах(
			Новый ОписаниеОповещения("ОбменВыполнен", ЭтотОбъект),
			Устройства, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПерезагрузить(Команда)
	
	Устройства = Новый Массив;
	Устройства.Добавить(Устройство);
	
	//++ Локализация
	Если ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыОфлайнОборудования.ККМ") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбменВыполнен", ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьПолнуюВыгрузкуПрайсЛистаНаККМ(Устройство,
			УникальныйИдентификатор,
			ОписаниеОповещения);
	КонецЕсли;
	//-- Локализация
	
	Если ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток") Тогда
		ПодключаемоеОборудованиеOfflineКлиент.ВыгрузитьПолныйСписокТоваровВВесы(
			Новый ОписаниеОповещения("ОбменВыполнен", ЭтотОбъект),
			Устройства, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыгрузить(Команда)
	
	Устройства = Новый Массив;
	Устройства.Добавить(Устройство);
	
	//++ Локализация
	Если ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыОфлайнОборудования.ККМ") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбменВыполнен", ЭтотОбъект);
		МенеджерОфлайнОборудованияКлиент.НачатьВыгрузкуДанныхНаККМ(Устройство, УникальныйИдентификатор, ОписаниеОповещения);
	КонецЕсли;
	//-- Локализация
	
	Если ТипОборудования = ПредопределенноеЗначение("Перечисление.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток") Тогда
		ПодключаемоеОборудованиеOfflineКлиент.ВыгрузитьТоварыВВесы(
			Новый ОписаниеОповещения("ОбменВыполнен", ЭтотОбъект),
			Устройства, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьЦенников(Команда)
	
	МенеджерОборудованияКлиент.ОбновитьРабочееМестоКлиента();
	АдресВХранилище = ДанныеДляПечатиЦенников();
	Если АдресВХранилище <> Неопределено Тогда
	
		СтруктураПараметры = Новый Структура("АдресВХранилище", АдресВХранилище);
		ОткрытьФорму(
			"Обработка.ПечатьЭтикетокИЦенников.Форма.ФормаТовары",
			СтруктураПараметры,            // Параметры
			,                              // Владелец
			Новый УникальныйИдентификатор); // Уникальность
	
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НапечататьКодыТоваров(Команда)
	
	МассивОбъектов = Новый Массив;
	МассивОбъектов.Добавить(ПравилоОбмена);
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Справочник.ПравилаОбменаСПодключаемымОборудованиемOffline",
		"КодыТоваров",
		МассивОбъектов,
		Неопределено,
		Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	ОтборПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьРегистрациюИзмененийДляВыделенныхСтрок(Команда)
	
	ОписаниеОшибки = "";
	МассивСтрок = Новый Массив;
	МассивКодов = Новый Массив;
	
	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		НайденнаяСтрока = Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		МассивСтрок.Добавить(НайденнаяСтрока);
		МассивКодов.Добавить(НайденнаяСтрока.Код);
	КонецЦикла;
	
	Если МассивКодов.Количество() > 0 Тогда
		Результат = УдалитьРегистрациюИзмененийНаСервере(МассивКодов);
		Если Результат Тогда
			Для Каждого СтрокаТЧ Из МассивСтрок Цикл
				СтрокаТЧ.ИндексКартинкиЕстьИзменения = 0;
			КонецЦикла;
			Оповестить("Запись_КодыТоваровПодключаемогоОборудования", Новый Структура, Неопределено);
		Иначе
			ПоказатьПредупреждение(
				Неопределено,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'В процессе удаления регистрации изменений произошла ошибка: %1'"),
					ОписаниеОшибки)); 
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(Неопределено, НСтр("ru = 'Не выбраны строки для удаления регистрации изменений'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	//++ Локализация
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыШтрихкод.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Штрихкод");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Используется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипОборудования");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыОфлайнОборудования.ККМ;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не задан штрихкод>'"));

	//

	//-- Локализация
	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыШтрихкод.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Штрихкод");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Используется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТипОборудования");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.ТипыПодключаемогоОборудования.ВесыСПечатьюЭтикеток;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<штрихкод будет сгенерирован при выгрузке>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыЦена.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Цена");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Используется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("ГоризонтальноеПоложение", ГоризонтальноеПоложение.Лево);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не задана цена>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыНаименование.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Наименование");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Используется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Не задано наименование>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыКод.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Код");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Больше;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("МаксимальныйКод");

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МаксимальныйКод");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Товары.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Используется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыТекстТребуетсяУказаниеСерий.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.ТребуетсяУказаниеСерий");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Товары.Используется");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Для товара требуется указание серий при отгрузке в розницу с данного склада>'"));

КонецПроцедуры

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ОтборПриИзмененииНаСервере()
	
	ПараметрыВыгрузки = ПодключаемоеОборудованиеOfflineВызовСервера.ПолучитьПараметрыУстройства(Устройство);
	
	Если Отбор = "Измененные" Тогда
		ПараметрыВыгрузки.Вставить("ЧастичнаяВыгрузка", Истина);
		Таблица = ПодключаемоеОборудованиеOfflineВызовСервера.ДанныеТоваровДляВыгрузки(Устройство, ПараметрыВыгрузки);
	ИначеЕсли Отбор = "СОшибками" Тогда
		ПараметрыВыгрузки.Вставить("ЧастичнаяВыгрузка", Ложь);
		Таблица = ПодключаемоеОборудованиеOfflineВызовСервера.ДанныеТоваровДляВыгрузки(Устройство, ПараметрыВыгрузки).Скопировать(Новый Структура("ЕстьОшибки", Истина));
	Иначе
		ПараметрыВыгрузки.Вставить("ЧастичнаяВыгрузка", Ложь);
		Таблица = ПодключаемоеОборудованиеOfflineВызовСервера.ДанныеТоваровДляВыгрузки(Устройство, ПараметрыВыгрузки);
	КонецЕсли;
	
	Если Таблица <> Неопределено Тогда
		Товары.Загрузить(Таблица);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция ДанныеДляПечатиЦенников()
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕСТЬNULL(СправочникПодключаемоеОборудование.ПравилоОбмена.Склад, НЕОПРЕДЕЛЕНО) КАК Склад,
	|	ЕСТЬNULL(КассыККМ.КассаККМ.Владелец, НЕОПРЕДЕЛЕНО) КАК Организация,
	|	ЕСТЬNULL(СправочникПодключаемоеОборудование.ПравилоОбмена.Склад.РозничныйВидЦены, НЕОПРЕДЕЛЕНО) КАК ВидЦены
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК СправочникПодключаемоеОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиРМК.КассыККМ КАК КассыККМ
	|		ПО КассыККМ.ПодключаемоеОборудование = СправочникПодключаемоеОборудование.Ссылка
	|		 И КассыККМ.Ссылка.РабочееМесто = &РабочееМесто
	|ГДЕ
	|	СправочникПодключаемоеОборудование.Ссылка = &Устройство";
	
	//++ Локализация
	ТекстЗапроса =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕСТЬNULL(СправочникПодключаемоеОборудование.ПравилоОбмена.Склад, НЕОПРЕДЕЛЕНО) КАК Склад,
	|	ЕСТЬNULL(КассыККМ.КассаККМ.Владелец, НЕОПРЕДЕЛЕНО) КАК Организация,
	|	ЕСТЬNULL(СправочникПодключаемоеОборудование.ПравилоОбмена.Склад.РозничныйВидЦены, НЕОПРЕДЕЛЕНО) КАК ВидЦены
	|ИЗ
	|	Справочник.ОфлайнОборудование КАК СправочникПодключаемоеОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиРМК.КассыККМ КАК КассыККМ
	|		ПО КассыККМ.ПодключаемоеОборудование = СправочникПодключаемоеОборудование.Ссылка
	|		 И КассыККМ.Ссылка.РабочееМесто = &РабочееМесто
	|ГДЕ
	|	СправочникПодключаемоеОборудование.Ссылка = &Устройство
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЕСТЬNULL(СправочникПодключаемоеОборудование.ПравилоОбмена.Склад, НЕОПРЕДЕЛЕНО) КАК Склад,
	|	ЕСТЬNULL(КассыККМ.КассаККМ.Владелец, НЕОПРЕДЕЛЕНО) КАК Организация,
	|	ЕСТЬNULL(СправочникПодключаемоеОборудование.ПравилоОбмена.Склад.РозничныйВидЦены, НЕОПРЕДЕЛЕНО) КАК ВидЦены
	|ИЗ
	|	Справочник.ПодключаемоеОборудование КАК СправочникПодключаемоеОборудование
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НастройкиРМК.КассыККМ КАК КассыККМ
	|		ПО КассыККМ.ПодключаемоеОборудование = СправочникПодключаемоеОборудование.Ссылка
	|		 И КассыККМ.Ссылка.РабочееМесто = &РабочееМесто
	|ГДЕ
	|	СправочникПодключаемоеОборудование.Ссылка = &Устройство";
	//-- Локализация
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Устройство", Устройство);
	Запрос.УстановитьПараметр("РабочееМесто", МенеджерОборудованияВызовСервера.ПолучитьРабочееМестоКлиента());
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Не Выборка.Следующий() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ТаблицаТовары = Новый ТаблицаЗначений;
	ТаблицаТовары.Колонки.Добавить("Номенклатура",   Новый ОписаниеТипов("СправочникСсылка.Номенклатура"));
	ТаблицаТовары.Колонки.Добавить("Характеристика", Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ТаблицаТовары.Колонки.Добавить("Упаковка",       Новый ОписаниеТипов("СправочникСсылка.УпаковкиЕдиницыИзмерения"));
	ТаблицаТовары.Колонки.Добавить("Количество",     Новый ОписаниеТипов("Число"));
	ТаблицаТовары.Колонки.Добавить("Порядок",        Новый ОписаниеТипов("Число"));
	
	Индекс = 1;
	Для Каждого ВыделеннаяСтрока Из Элементы.Товары.ВыделенныеСтроки Цикл
		
		СтрокаТЧ = Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		
		НоваяСтрока = ТаблицаТовары.Добавить();
		НоваяСтрока.Номенклатура   = СтрокаТЧ.Номенклатура;
		НоваяСтрока.Характеристика = СтрокаТЧ.Характеристика;
		НоваяСтрока.Упаковка       = СтрокаТЧ.Упаковка;
		НоваяСтрока.Количество     = 1;
		НоваяСтрока.Порядок        = Индекс;
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	// Подготовка структуры действий для обработки печати ценников и этикеток
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьОрганизацию",   Выборка.Организация);
	СтруктураДействий.Вставить("ЗаполнитьСклад",         Выборка.Склад);
	СтруктураДействий.Вставить("ЗаполнитьВидЦены",       Выборка.ВидЦены);
	СтруктураДействий.Вставить("ЗаполнитьПравилоОбмена", ПравилоОбмена);
	СтруктураДействий.Вставить("ПоказыватьКолонкуКоличествоВДокументе", Истина);
	СтруктураДействий.Вставить("УстановитьРежимПечатиИзДокумента");
	СтруктураДействий.Вставить("УстановитьРежим", "ПечатьЦенников");
	СтруктураДействий.Вставить("ЗаполнитьКоличествоЦенниковПоДокументу");
	СтруктураДействий.Вставить("ЗаполнитьТаблицуТоваров");
	
	// Подготовка данных для заполенения табличной части обработки печати ценников и этикеток.
	СтруктураРезультат = Новый Структура;
	СтруктураРезультат.Вставить("Товары", ТаблицаТовары);
	СтруктураРезультат.Вставить("СтруктураДействий", СтруктураДействий);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураРезультат, Новый УникальныйИдентификатор());
	
КонецФункции

&НаСервере
Функция ЗарегистрироватьИзмененияНаСервере(МассивКодов, ОписаниеОшибки = "")
	
	ВозвращаемоеЗначение = Истина;
	
	НачатьТранзакцию();
	Попытка
		
		Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
		Для Каждого Код Из МассивКодов Цикл
			
			Набор.Отбор.ПравилоОбмена.Значение = ПравилоОбмена;
			Набор.Отбор.ПравилоОбмена.Использование = Истина;
			
			Набор.Отбор.Код.Значение = Код;
			Набор.Отбор.Код.Использование = Истина;
			
			ПланыОбмена.ЗарегистрироватьИзменения(УзелИнформационнойБазы, Набор);
			
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Розничные продажи'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВозвращаемоеЗначение = Ложь;
		ОписаниеОшибки = ИнформацияОбОшибке().Описание;
		
	КонецПопытки;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаСервере
Функция УдалитьРегистрациюИзмененийНаСервере(МассивКодов, ОписаниеОшибки = "")
	
	ВозвращаемоеЗначение = Истина;
	
	НачатьТранзакцию();
	Попытка
		
		Набор = РегистрыСведений.КодыТоваровПодключаемогоОборудованияOffline.СоздатьНаборЗаписей();
		Для Каждого Код Из МассивКодов Цикл
			
			Набор.Отбор.ПравилоОбмена.Значение = ПравилоОбмена;
			Набор.Отбор.ПравилоОбмена.Использование = Истина;
			
			Набор.Отбор.Код.Значение = Код;
			Набор.Отбор.Код.Использование = Истина;
			
			ПланыОбмена.УдалитьРегистрациюИзменений(УзелИнформационнойБазы, Набор);
			
		КонецЦикла;
		
		Если Отбор = "Измененные" Тогда
			ОтборПриИзмененииНаСервере();
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Розничные продажи'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВозвращаемоеЗначение = Ложь;
		ОписаниеОшибки = ИнформацияОбОшибке().Описание;
		
	КонецПопытки;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

&НаКлиенте
Процедура ОбменВыполнен(ВозвращаемоеЗначение, ДополнительныеПараметры) Экспорт
	
	ОчиститьСообщения();
	Если ВозвращаемоеЗначение.Свойство("Результат") И Не ВозвращаемоеЗначение.Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ВозвращаемоеЗначение.ОписаниеОшибки);
	ИначеЕсли Не ВозвращаемоеЗначение.Свойство("Результат") И ВозвращаемоеЗначение.Выполнено <> ВозвращаемоеЗначение.ТребуетсяВыполнить Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ВозвращаемоеЗначение.ТекстСообщения);
	ИначеЕсли Не ВозвращаемоеЗначение.Свойство("Результат") И ВозвращаемоеЗначение.Выполнено = ВозвращаемоеЗначение.ТребуетсяВыполнить Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Данные успешно выгружены'"));
	Иначе
		
		Если ТипЗнч(ДополнительныеПараметры) = Тип("Структура") 
			И ДополнительныеПараметры.Свойство("ЭтоЗагрузка") Тогда

			ТекстСообщения = ?(ВозвращаемоеЗначение.Результат, НСтр("ru='Данные успешно загружены'"), НСтр("ru='При загрузке данных произошла ошибка'"));
		Иначе
			ТекстСообщения = ?(ВозвращаемоеЗначение.Результат, НСтр("ru='Данные успешно выгружены'"), НСтр("ru='При выгрузке данных произошла ошибка'"));
		КонецЕсли;
		
		Если ВозвращаемоеЗначение.Свойство("ОписаниеОшибки") И Не ПустаяСтрока(ВозвращаемоеЗначение.ОписаниеОшибки) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ВозвращаемоеЗначение.ОписаниеОшибки);
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
	Оповестить("Запись_ПравилаОбменаСПодключаемымОборудованиемOffline", Новый Структура, Неопределено);
	ОтборПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
