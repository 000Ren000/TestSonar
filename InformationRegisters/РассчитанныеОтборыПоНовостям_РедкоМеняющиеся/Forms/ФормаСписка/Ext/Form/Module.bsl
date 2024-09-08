﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если ОбработкаНовостейПовтИсп.ЕстьРольАдминистраторСистемы()
			И ОбработкаНовостейПовтИсп.ЕстьРольПолныеПрава() Тогда
		Элементы.СписокКомандаПересчитатьОтборы.Видимость = Истина;
	Иначе
		Элементы.СписокКомандаПересчитатьОтборы.Видимость = Ложь;
	КонецЕсли;

	УстановитьУсловноеОформление();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПересчитатьОтборы(Команда)

	// Удалить неправильные отборы, которые могут помешать проверке общих и пользовательских отборов.
	// В разделенном сеансе будут пересчитаны только пользовательские отборы и общие для области данных.
	ОбработкаНовостейВызовСервера.ОптимизироватьОтборыПоНовостям(Неопределено);

	// Пересчитать отборы.
	ОбработкаНовостейВызовСервера.ПересчитатьОтборыПоНовостям_РедкоМеняющиеся(Неопределено);

	Элементы.Список.Обновить();

КонецПроцедуры

&НаКлиенте
Процедура КомандаСкрытьОтобразитьПодсказку(Команда)

	Если Элементы.ДекорацияПодсказка.Высота = 1 Тогда
		Элементы.ДекорацияПодсказка.Высота = 5;
	Иначе
		Элементы.ДекорацияПодсказка.Высота = 1;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура устанавливает условное оформление в форме
//
// Параметры:
//  Нет
//
&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// 1. Версия платформы, скрыта
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоВерсииПлатформы.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоВерсииПлатформы");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 0;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветИнформацияОшибочна);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Скрыта'"));

		// Использование
		Элемент.Использование = Истина;

	// 2. Версия платформы, видна
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоВерсииПлатформы.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоВерсииПлатформы");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 1;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Видна'"));

		// Использование
		Элемент.Использование = Истина;

	// 3. Версия платформы, отбор не настроен - видна
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоВерсииПлатформы.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоВерсииПлатформы");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 2;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Отбор не настроен, видна'"));

		// Использование
		Элемент.Использование = Истина;

	// 4. Версия продукта, скрыта
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоВерсииПродукта.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоВерсииПродукта");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 0;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветИнформацияОшибочна);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Скрыта'"));

		// Использование
		Элемент.Использование = Истина;

	// 5. Версия продукта, видна
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоВерсииПродукта.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоВерсииПродукта");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 1;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Видна'"));

		// Использование
		Элемент.Использование = Истина;

	// 6. Версия продукта, отбор не настроен - видна
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоВерсииПродукта.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоВерсииПродукта");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 2;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Отбор не настроен, видна'"));

		// Использование
		Элемент.Использование = Истина;

	// 7. Продукт, скрыта
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоПродукту.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоПродукту");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 0;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветИнформацияОшибочна);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Скрыта'"));

		// Использование
		Элемент.Использование = Истина;

	// 8. Продукт, видна
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоПродукту.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоПродукту");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 1;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Видна'"));

		// Использование
		Элемент.Использование = Истина;

	// 9. Продукт, отбор не настроен - видна
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоПродукту.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоПродукту");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = 2;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Отбор не настроен, видна'"));

		// Использование
		Элемент.Использование = Истина;

	// 10. Пометка удаления, скрыта
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоПометкеУдаления.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоПометкеУдаления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветИнформацияОшибочна);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Скрыта'"));

		// Использование
		Элемент.Использование = Истина;

	// 11. Пометка удаления, видна
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоПометкеУдаления.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоПометкеУдаления");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Видна'"));

		// Использование
		Элемент.Использование = Истина;

	// 12. Дата завершения, скрыта
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоДатеЗавершения.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоДатеЗавершения");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветИнформацияОшибочна);
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Скрыта'"));

		// Использование
		Элемент.Использование = Истина;

	// 13. Дата завершения, видна
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбораПоДатеЗавершения.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбораПоДатеЗавершения");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Истина;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Видна'"));

		// Использование
		Элемент.Использование = Истина;

	// 14. Общий результат, скрыта
		Элемент = УсловноеОформление.Элементы.Добавить();

		// Оформляемые поля
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.РезультатОтбора.Имя);

		// Отбор
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.РезультатОтбора");
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = Ложь;

		// Оформление
		Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ЦветИнформацияОшибочна);

		// Использование
		Элемент.Использование = Истина;

КонецПроцедуры

#КонецОбласти
