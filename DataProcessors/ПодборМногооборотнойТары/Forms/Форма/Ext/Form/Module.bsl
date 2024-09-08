﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(Параметры.АдресТоваровВоВременномХранилище) Тогда
		ТоварыДокумента.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресТоваровВоВременномХранилище));

		ПоказыватьСклад = Параметры.ПоказыватьСклад;
		ПоказыватьДату = Параметры.ПоказыватьДату;

		ЗаполнитьДеревоМногооборотнойТары();
		ОбновитьПредупреждающуюНадпись(Элементы);
	Иначе
		ВызватьИсключение НСтр("ru='Обработка не предназначена для непосредственного использования.'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ПринудительноЗакрытьФорму Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПеренестиВДокумент И Модифицированность И НЕ ЗавершениеРаботы Тогда
		
		Отказ = Истина;
		ПоказатьВопрос(
			Новый ОписаниеОповещения("ПередЗакрытиемВопросЗавершение", ЭтотОбъект),
			НСтр("ru = 'Многооборотная тара не перенесена в документ. Перенести?'"), РежимДиалогаВопрос.ДаНетОтмена);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемВопросЗавершение(ОтветНаВопрос, ДополнительныеПараметры) Экспорт
	
	Если ОтветНаВопрос = КодВозвратаДиалога.Да Тогда
		ПеренестиВДокумент = Истина;
		Закрыть();
	ИначеЕсли ОтветНаВопрос = КодВозвратаДиалога.Нет Тогда
		ПринудительноЗакрытьФорму = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ПеренестиВДокумент И НЕ ЗавершениеРаботы Тогда
		
		АдресМногооборотнойТарыВХранилище = ПоместитьТаруВХранилище();
		
		Если Не АдресМногооборотнойТарыВХранилище=Неопределено Тогда
	
			Структура = Новый Структура("ТараПодобрана,АдресМногооборотнойТарыВХранилище", Истина, АдресМногооборотнойТарыВХранилище);
			ПеренестиВДокумент = Истина;
			ОповеститьОВыборе(Структура);
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура УстановитьЗначенияПодчиненных(СтрокаДерева)
	
	Строки = СтрокаДерева.ПолучитьЭлементы();
	Если СтрокаДерева.ПодобранноеКоличествоТары = 0 Тогда
		СтрокаДерева.ПодобранноеКоличествоТары = СтрокаДерева.КоличествоНоменклатуры;
	КонецЕсли;		
	Если Строки.Количество()>0 Тогда
		Для каждого Стр Из Строки Цикл
			Стр.Выбрана = СтрокаДерева.Выбрана;
			УстановитьЗначенияПодчиненных(Стр);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТараВыбранаПриИзменении(Элемент)
	
	ОбновитьПредупреждающуюНадпись(Элементы, Элементы.Тара.ТекущиеДанные);
	УстановитьЗначенияПодчиненных(Элементы.Тара.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Завершить(Команда)
	
	ПеренестиВДокумент = Истина;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	ПеренестиВДокумент = Ложь;
	Закрыть(Неопределено);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараПодобранноеКоличествоТары.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараКоличествоТарыВДокументе.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;

	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.ПодобранноеКоличествоТары");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Тара.РекомендуемоеКоличествоТары");

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Выбрана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ГруппаОтбора2 = ГруппаОтбора1.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.КоличествоТарыВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Тара.РекомендуемоеКоличествоТары");

	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Выбрана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.FireBrick);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараЕдиницаИзмерения.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараНоменклатура.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараХарактеристика.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Упаковка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараУпаковка.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Упаковка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараКоличествоНоменклатуры.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Упаковка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("Формат", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараВыбрана.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.НоменклатураМногооборотнаяТара");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараНоменклатура.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.DarkGray);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<тара без товара>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараПодобранноеКоличествоТары.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Выбрана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.DefaultGUIFont, , , Истина, Ложь, Ложь, Ложь, ));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараПодобранноеКоличествоТары.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Выбрана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.КоличествоТарыВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.ПодобранноеКоличествоТары");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<удалить>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараПодобранноеКоличествоТары.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Выбрана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараКоличествоТарыВДокументе.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Выбрана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("Отображать", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараПодобранноеКоличествоТары.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараКоличествоТарыВДокументе.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.КоличествоТарыВДокументе");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.ПодобранноеКоличествоТары");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.НоменклатураМногооборотнаяТара");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.Выбрана");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстСправочнойНадписи);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не подбирать>'"));

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараПодобранноеКоличествоТары.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараНоменклатураМногооборотнаяТара.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараКоличествоТарыВДокументе.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Тара.НоменклатураМногооборотнаяТара");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НезаполненноеПолеТаблицы);
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));
	
	Элементы.Тара.НачальноеОтображениеДерева = НачальноеОтображениеДерева.НеРаскрывать;	

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараСклад.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоказыватьСклад");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТараДата.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ПоказыватьДату");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);

КонецПроцедуры

#Область Прочее

&НаСервере
Процедура ЗаполнитьДеревоМногооборотнойТары()
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТоварыДокумента.Номенклатура       КАК Номенклатура,
	|	ТоварыДокумента.Характеристика     КАК Характеристика,
	|	ТоварыДокумента.Количество         КАК Количество,
	|	ТоварыДокумента.Склад              КАК Склад,
	|	ТоварыДокумента.Дата               КАК Дата
	|ПОМЕСТИТЬ
	|	ВтТоварыДокумента
	|ИЗ
	|	&ТоварыДокумента КАК ТоварыДокумента
	|ГДЕ
	|	ТоварыДокумента.Количество > 0
	|;
	|ВЫБРАТЬ
	|	ВтТоварыДокумента.Номенклатура                                  КАК Номенклатура,
	|	ВтТоварыДокумента.Характеристика                                КАК Характеристика,
	|	ВтТоварыДокумента.Склад                                         КАК Склад,
	|	ВтТоварыДокумента.Дата                                          КАК Дата,
	|	0                                                               КАК КоличествоНоменклатуры,
	|	0                                                               КАК КоличествоТоваровДокумента,
	|	ВтТоварыДокумента.Номенклатура.НоменклатураМногооборотнаяТара   КАК НоменклатураМногооборотнаяТара,
	|	ВтТоварыДокумента.Номенклатура.ХарактеристикаМногооборотнаяТара КАК ХарактеристикаМногооборотнаяТара,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)      КАК Упаковка,
	|	0                                                               КАК МинимальноеКоличествоУпаковокМногооборотнойТары
	|
	|ПОМЕСТИТЬ
	|	ВтТара
	|ИЗ
	|	ВтТоварыДокумента КАК ВтТоварыДокумента
	|ГДЕ
	|	ВтТоварыДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|	И ВтТоварыДокумента.Номенклатура.ПоставляетсяВМногооборотнойТаре
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВтТоварыДокумента.Номенклатура                                  КАК Номенклатура,
	|	ВтТоварыДокумента.Характеристика                                КАК Характеристика,
	|	ВтТоварыДокумента.Склад                                         КАК Склад,
	|	ВтТоварыДокумента.Дата                                          КАК Дата,
	|	ВтТоварыДокумента.Количество                                    КАК КоличествоНоменклатуры,
	|	0                                                               КАК КоличествоТоваровДокумента,
	|	ЗНАЧЕНИЕ(Справочник.Номенклатура.ПустаяСсылка)                  КАК НоменклатураМногооборотнаяТара,
	|	ЗНАЧЕНИЕ(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)    КАК ХарактеристикаМногооборотнаяТара,
	|	ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)      КАК Упаковка,
	|	0                                                               КАК МинимальноеКоличествоУпаковокМногооборотнойТары
	|ИЗ
	|	ВтТоварыДокумента КАК ВтТоварыДокумента
	|ГДЕ
	|	ВтТоварыДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВтТоварыДокумента.Номенклатура                                           КАК Номенклатура,
	|	ВтТоварыДокумента.Характеристика                                         КАК Характеристика,
	|	ВтТоварыДокумента.Склад                                                  КАК Склад,
	|	ВтТоварыДокумента.Дата                                                   КАК Дата,
	|	ВЫРАЗИТЬ(ВтТоварыДокумента.Количество / &ТекстЗапросаКоэффициентУпаковки1 КАК ЧИСЛО(15,0)) КАК КоличествоНоменклатуры,
	|	ВтТоварыДокумента.Количество                                             КАК КоличествоТоваровДокумента,
	|	УпаковкиНоменклатуры.НоменклатураМногооборотнаяТара                      КАК НоменклатураМногооборотнаяТара,
	|	УпаковкиНоменклатуры.ХарактеристикаМногооборотнаяТара                    КАК ХарактеристикаМногооборотнаяТара,
	|	ЕСТЬNULL(УпаковкиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) КАК Упаковка,
	|	УпаковкиНоменклатуры.МинимальноеКоличествоУпаковокМногооборотнойТары     КАК МинимальноеКоличествоУпаковокМногооборотнойТары
	|ИЗ
	|	ВтТоварыДокумента КАК ВтТоварыДокумента
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|ПО
	|	ВтТоварыДокумента.Номенклатура.НаборУпаковок = УпаковкиНоменклатуры.Владелец
	|	ИЛИ (ВтТоварыДокумента.Номенклатура.НаборУпаковок = ЗНАЧЕНИЕ(Справочник.НаборыУпаковок.ИндивидуальныйДляНоменклатуры)
	|		И ВтТоварыДокумента.Номенклатура = УпаковкиНоменклатуры.Владелец)
	|ГДЕ
	|	ВтТоварыДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.Товар)
	|	И НЕ УпаковкиНоменклатуры.ПометкаУдаления
	|	И УпаковкиНоменклатуры.ТипУпаковки <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|;
	|ВЫБРАТЬ
	|	втТара.Номенклатура                                                        КАК Номенклатура,
	|	втТара.Характеристика                                                      КАК Характеристика,
	|	втТара.Склад                                                               КАК Склад,
	|	втТара.Дата                                                                КАК Дата,
	|	втТара.Упаковка                                                            КАК Упаковка,
	|	ВЫБОР
	|		КОГДА
	|			втТара.Упаковка.ТипУпаковки = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.Составная)
	|		ТОГДА
	|			втТара.Упаковка.КоличествоУпаковок
	|		ИНАЧЕ
	|			&ТекстЗапросаКоэффициентУпаковки2
	|	КОНЕЦ КАК КоличествоУпаковок,
	|	втТара.Упаковка.Родитель                                                   КАК Родитель,
	|	втТара.Номенклатура.ЕдиницаИзмерения                                       КАК ЕдиницаИзмерения,
	|	МАКСИМУМ(втТара.МинимальноеКоличествоУпаковокМногооборотнойТары)           КАК МинимальноеКоличествоУпаковокМногооборотнойТары,
	|	МАКСИМУМ(втТара.НоменклатураМногооборотнаяТара)                            КАК НоменклатураМногооборотнаяТара,
	|	МАКСИМУМ(втТара.ХарактеристикаМногооборотнаяТара)                          КАК ХарактеристикаМногооборотнаяТара,
	|	МАКСИМУМ(втТара.КоличествоТоваровДокумента) 							   КАК КоличествоТоваровДокумента,
	|	МАКСИМУМ(втТара.КоличествоНоменклатуры)                                    КАК КоличествоНоменклатуры
	|ИЗ
	|	втТара КАК втТара
	|СГРУППИРОВАТЬ ПО
	|	втТара.Номенклатура,
	|	втТара.Характеристика,
	|	втТара.Склад,
	|	втТара.Дата,
	|	втТара.Упаковка
	|УПОРЯДОЧИТЬ ПО
	|	втТара.Номенклатура,
	|	втТара.Характеристика,
	|	втТара.Склад,
	|	втТара.Дата,
	|	КоличествоУпаковок Убыв,
	|	втТара.Упаковка
	|ИТОГИ
	|	МАКСИМУМ(НоменклатураМногооборотнаяТара),
	|	МАКСИМУМ(ХарактеристикаМногооборотнаяТара)
	|ПО
	|	втТара.Номенклатура,
	|	втТара.Характеристика,
	|	втТара.Склад,
	|	втТара.Дата
	|;
	|ВЫБРАТЬ
	|	ВтТоварыДокумента.Номенклатура       КАК Номенклатура,
	|	ВтТоварыДокумента.Характеристика     КАК Характеристика,
	|	ВтТоварыДокумента.Склад              КАК Склад,
	|	ВтТоварыДокумента.Дата               КАК Дата,
	|	СУММА(ВтТоварыДокумента.Количество)  КАК НачальноеКоличествоТары,
	|	СУММА(ВтТоварыДокумента.Количество)  КАК КоличествоТары,
	|	НЕОПРЕДЕЛЕНО                         КАК СтрокаДерева
	|ИЗ
	|	ВтТоварыДокумента КАК ВтТоварыДокумента
	|ГДЕ
	|	ВтТоварыДокумента.Номенклатура.ТипНоменклатуры = ЗНАЧЕНИЕ(Перечисление.ТипыНоменклатуры.МногооборотнаяТара)
	|СГРУППИРОВАТЬ ПО
	|	ВтТоварыДокумента.Номенклатура,
	|	ВтТоварыДокумента.Характеристика,
	|	ВтТоварыДокумента.Склад,
	|	ВтТоварыДокумента.Дата
	|УПОРЯДОЧИТЬ ПО
	|	ВтТоварыДокумента.Номенклатура.Наименование,
	|	ВтТоварыДокумента.Характеристика.Наименование,
	|	ВтТоварыДокумента.Склад.Наименование,
	|	ВтТоварыДокумента.Дата";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки1",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"УпаковкиНоменклатуры", Неопределено));
		
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,
		"&ТекстЗапросаКоэффициентУпаковки2",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
		"втТара.Упаковка",
		"втТара.Номенклатура"));
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Товары = ТоварыДокумента.Выгрузить();
	Товары.Свернуть("Дата, Номенклатура, Характеристика, Склад", "Количество");
	ТоварыСУпаковкойВсей = Новый ТаблицаЗначений();
	ТоварыСУпаковкойВсей = 	ТоварыДокумента.Выгрузить();
	ТоварыСУпаковкойВсей.Свернуть("Дата, Номенклатура, Характеристика,Упаковка,Склад", "Количество");	
	ТоварыСУпаковкой = Новый ТаблицаЗначений(); 
	ТоварыСУпаковкой.Колонки.Добавить("Дата");
	ТоварыСУпаковкой.Колонки.Добавить("Номенклатура");
	ТоварыСУпаковкой.Колонки.Добавить("Характеристика");
	ТоварыСУпаковкой.Колонки.Добавить("Упаковка");
	ТоварыСУпаковкой.Колонки.Добавить("Склад");
	Для каждого Стр Из ТоварыСУпаковкойВсей Цикл
		Если ЗначениеЗаполнено(Стр.Упаковка) Тогда
			СтрНов = ТоварыСУпаковкой.Добавить();
			ЗаполнитьЗначенияСвойств(СтрНов,Стр);
		КонецЕсли;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("ТоварыДокумента", Товары);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ТараСтроки = Тара.ПолучитьЭлементы();
	ТараСтроки.Очистить();
	ДеревоТара = РеквизитФормыВЗначение("Тара");
	ВсяТараПодобрана = Истина;
	
	Если Не РезультатЗапроса[2].Пустой() Тогда
		
		ВыборкаНоменклатура = РезультатЗапроса[2].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		ТараДокумента = РезультатЗапроса[3].Выгрузить();
		
		Пока ВыборкаНоменклатура.Следующий() Цикл
			
			ВыборкаХарактеристики = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
			Пока ВыборкаХарактеристики.Следующий() Цикл
				
				ВыборкаСклады = ВыборкаХарактеристики.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаСклады.Следующий() Цикл
				
					ВыборкаДаты = ВыборкаСклады.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					
					Пока ВыборкаДаты.Следующий() Цикл
						
						ВыборкаУпаковки = ВыборкаДаты.Выбрать();
						
						ТаблицаУпаковок = Новый ТаблицаЗначений();
						ТаблицаУпаковок.Колонки.Добавить("Номенклатура");
						ТаблицаУпаковок.Колонки.Добавить("Характеристика");
						ТаблицаУпаковок.Колонки.Добавить("Склад");
						ТаблицаУпаковок.Колонки.Добавить("Дата");
						ТаблицаУпаковок.Колонки.Добавить("Упаковка");
						ТаблицаУпаковок.Колонки.Добавить("Родитель");
						ТаблицаУпаковок.Колонки.Добавить("КоличествоНоменклатуры");
						ТаблицаУпаковок.Колонки.Добавить("КоличествоУпаковок");
						ТаблицаУпаковок.Колонки.Добавить("НоменклатураМногооборотнаяТара");
						ТаблицаУпаковок.Колонки.Добавить("ХарактеристикаМногооборотнаяТара");
						ТаблицаУпаковок.Колонки.Добавить("МинимальноеКоличествоУпаковокМногооборотнойТары");
						
						ТаблицаУпаковок.Сортировать("КоличествоНоменклатуры Убыв");
						
						Пока ВыборкаУпаковки.Следующий() Цикл
							
							Если ЗначениеЗаполнено(ВыборкаУпаковки.Упаковка) Тогда
								
								НоваяСтрокаУпаковка = ТаблицаУпаковок.Добавить();
								ЗаполнитьЗначенияСвойств(НоваяСтрокаУпаковка, ВыборкаУпаковки);
								
								Если ЗначениеЗаполнено(НоваяСтрокаУпаковка.НоменклатураМногооборотнаяТара) 
									И ВыборкаУпаковки.Упаковка.ПоставляетсяВМногооборотнойТаре
									И ВыборкаУпаковки.КоличествоУпаковок > 0 Тогда
									
									Если ВыборкаУпаковки.Упаковка.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Конечная Тогда
										КоличествоТары = Цел(ВыборкаУпаковки.КоличествоТоваровДокумента/ВыборкаУпаковки.КоличествоУпаковок);
										ОстатокТары = ВыборкаУпаковки.КоличествоТоваровДокумента - ВыборкаУпаковки.КоличествоУпаковок*КоличествоТары;
									ИначеЕсли ВыборкаУпаковки.Упаковка.ТипУпаковки = Перечисления.ТипыУпаковокНоменклатуры.Составная Тогда
                                        КоличествоТары = Цел(ВыборкаУпаковки.КоличествоТоваровДокумента/(ВыборкаУпаковки.Упаковка.Числитель/ВыборкаУпаковки.Упаковка.Знаменатель));
										ОстатокТары = ВыборкаУпаковки.КоличествоТоваровДокумента - ВыборкаУпаковки.КоличествоУпаковок*(ВыборкаУпаковки.Упаковка.Числитель/ВыборкаУпаковки.Упаковка.Знаменатель)*КоличествоТары;
									КонецЕсли;
									
									Если ОстатокТары > 0 
										И ОстатокТары >= НоваяСтрокаУпаковка.МинимальноеКоличествоУпаковокМногооборотнойТары
										И НоваяСтрокаУпаковка.МинимальноеКоличествоУпаковокМногооборотнойТары > 0 Тогда
										КоличествоТары = КоличествоТары + 1;
									КонецЕсли; 
									НоваяСтрокаУпаковка.КоличествоНоменклатуры = КоличествоТары; 
								КонецЕсли;
							Иначе
								
								НоваяСтрока = ДеревоТара.Строки.Добавить();
								ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаУпаковки);
								
								Если ЗначениеЗаполнено(НоваяСтрока.НоменклатураМногооборотнаяТара) Тогда
									
									НоваяСтрока.РекомендуемоеКоличествоТары = Цел(НоваяСтрока.КоличествоНоменклатуры);
									НоваяСтрока.ПодобранноеКоличествоТары = НоваяСтрока.РекомендуемоеКоличествоТары;
									
									ЗаполнитьКоличествоТарыИзДокумента(ТараДокумента, НоваяСтрока, ВсяТараПодобрана, ТоварыСУпаковкой);
									
								КонецЕсли;
								
							КонецЕсли;
								
						КонецЦикла;
						
						ВывестиПодчиненныеУпаковки(
							НоваяСтрока.Строки,
							Справочники.УпаковкиЕдиницыИзмерения.ПустаяСсылка(),
							ТаблицаУпаковок,
							ТараДокумента,
							ВсяТараПодобрана,
							ТоварыСУпаковкой);
								
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
		
		Для Каждого ТекСтрока Из ТараДокумента Цикл
			
			Если ТекСтрока.НачальноеКоличествоТары = ТекСтрока.КоличествоТары Тогда
				
				НоваяСтрока = ДеревоТара.Строки.Добавить();
				НоваяСтрока.НоменклатураМногооборотнаяТара = ТекСтрока.Номенклатура;
				НоваяСтрока.ХарактеристикаМногооборотнаяТара = ТекСтрока.Характеристика;
				НоваяСтрока.КоличествоТарыВДокументе = ТекСтрока.КоличествоТары;
				НоваяСтрока.Склад = ТекСтрока.Склад;
				НоваяСтрока.Дата = ТекСтрока.Дата;
				НоваяСтрока.Выбрана = Истина;
				ВсяТараПодобрана = Ложь;
				
			ИначеЕсли ТекСтрока.КоличествоТары > 0 И ТекСтрока.СтрокаДерева <> Неопределено Тогда
				
				ТекСтрока.СтрокаДерева.КоличествоТарыВДокументе = ТекСтрока.СтрокаДерева.КоличествоТарыВДокументе + ТекСтрока.КоличествоТары;
				
				Если ТекСтрока.СтрокаДерева.КоличествоТарыВДокументе <> ТекСтрока.СтрокаДерева.ПодобранноеКоличествоТары Тогда
					ТекСтрока.СтрокаДерева.Выбрана = Истина;
					ВсяТараПодобрана = Ложь;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
				
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ДеревоТара, "Тара");
	
	Если РезультатЗапроса[2].Пустой() Тогда
		ИнформационнаяНадпись = НСтр("ru='В документе отсутствуют товары. Многооборотная тара не требуется.'");
	ИначеЕсли Тара.ПолучитьЭлементы().Количество() = 0 Тогда
		ИнформационнаяНадпись = НСтр("ru='Для указанных в документе товаров многооборотная тара не требуется.'");
	Иначе
		
		Если ВсяТараПодобрана Тогда
			ИнформационнаяНадпись = НСтр("ru='Вся необходимая многооборотная тара уже подобрана в документ.'");
		Иначе
			ИнформационнаяНадпись = НСтр("ru='Нажмите ""Завершить"" для переноса подобранной многооборотной тары в документ.'");
			Модифицированность = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВывестиПодчиненныеУпаковки(УпаковкиСтроки, УпаковкаУзел, ТаблицаУпаковок, ТараДокумента, ВсяТараПодобрана, ТоварыСУпаковкой)
	
	ПодчиненныеУпаковки = ТаблицаУпаковок.НайтиСтроки(Новый Структура("Родитель", УпаковкаУзел));
	КоличествоНоменклатуры = УпаковкиСтроки.Родитель.КоличествоНоменклатуры;
	КоличествоНоменклатурыКРаспределению = КоличествоНоменклатуры;
	
	Для Каждого ТекСтрока Из ПодчиненныеУпаковки Цикл
		
		НоваяСтрокаУпаковка = УпаковкиСтроки.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаУпаковка, ТекСтрока);
		
		Если ЗначениеЗаполнено(НоваяСтрокаУпаковка.НоменклатураМногооборотнаяТара) И ТекСтрока.Упаковка.ПоставляетсяВМногооборотнойТаре Тогда
		
			КоличествоТары = Цел(КоличествоНоменклатурыКРаспределению/ТекСтрока.КоличествоУпаковок);
			ОстатокТары = КоличествоНоменклатурыКРаспределению - ТекСтрока.КоличествоУпаковок*КоличествоТары;
			
			Если ОстатокТары > 0 
				И ОстатокТары >= ТекСтрока.МинимальноеКоличествоУпаковокМногооборотнойТары
				И ТекСтрока.МинимальноеКоличествоУпаковокМногооборотнойТары > 0 Тогда
				КоличествоТары = КоличествоТары + 1;
				ОстатокТары = 0;
			КонецЕсли;
			
			Если КоличествоТары > 0 Тогда
				НоваяСтрокаУпаковка.РекомендуемоеКоличествоТары = КоличествоТары;
				НоваяСтрокаУпаковка.ПодобранноеКоличествоТары = НоваяСтрокаУпаковка.РекомендуемоеКоличествоТары;
				КоличествоНоменклатурыКРаспределению = ОстатокТары;
			КонецЕсли;
			
		КонецЕсли;
		
		ЗаполнитьКоличествоТарыИзДокумента(ТараДокумента, НоваяСтрокаУпаковка, ВсяТараПодобрана, ТоварыСУпаковкой);
			
		ВывестиПодчиненныеУпаковки(
			НоваяСтрокаУпаковка.Строки,
			ТекСтрока.Упаковка,
			ТаблицаУпаковок,
			ТараДокумента,
			ВсяТараПодобрана,
			ТоварыСУпаковкой);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКоличествоТарыИзДокумента(ТараДокумента, СтрокаДерева, ВсяТараПодобрана, ТоварыСУпаковкой)
	
	ИспользованиеХарактеристик = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаДерева.НоменклатураМногооборотнаяТара, "ИспользованиеХарактеристик");
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Номенклатура", СтрокаДерева.НоменклатураМногооборотнаяТара);
	ПараметрыОтбора.Вставить("Склад", СтрокаДерева.Склад);
	ПараметрыОтбора.Вставить("Дата", СтрокаДерева.Дата);
	
	Если ИспользованиеХарактеристик <> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать
		И НЕ ЗначениеЗаполнено(СтрокаДерева.ХарактеристикаМногооборотнаяТара) Тогда
		
		ТараДокументаСтроки = ТараДокумента.НайтиСтроки(ПараметрыОтбора);
		
	Иначе
		
		ПараметрыОтбора.Вставить("Характеристика", СтрокаДерева.ХарактеристикаМногооборотнаяТара);		
		ТараДокументаСтроки = ТараДокумента.НайтиСтроки(ПараметрыОтбора);
		
	КонецЕсли;
	
	Если ТараДокументаСтроки.Количество() > 0 И ТараДокументаСтроки[0].КоличествоТары > 0  Тогда
		
		СтрокаДерева.КоличествоТарыВДокументе = Мин(СтрокаДерева.РекомендуемоеКоличествоТары, ТараДокументаСтроки[0].КоличествоТары);
		ТараДокументаСтроки[0].КоличествоТары = ТараДокументаСтроки[0].КоличествоТары - СтрокаДерева.КоличествоТарыВДокументе;
		ТараДокументаСтроки[0].СтрокаДерева = СтрокаДерева;
		
	КонецЕсли;
	
	ТараДокументаСтрокиСУпаковкой = Новый Массив();
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Номенклатура", СтрокаДерева.Номенклатура);
	ПараметрыОтбора.Вставить("Склад", СтрокаДерева.Склад);
	ПараметрыОтбора.Вставить("Дата", СтрокаДерева.Дата);
	ЕстьВыбраннаяУпаковка = Ложь;
	
	Если ИспользованиеХарактеристик <> Перечисления.ВариантыИспользованияХарактеристикНоменклатуры.НеИспользовать
	И НЕ ЗначениеЗаполнено(СтрокаДерева.ХарактеристикаМногооборотнаяТара) Тогда
		
		ТараДокументаСтрокиСУпаковкой = ТоварыСУпаковкой.НайтиСтроки(ПараметрыОтбора);
		
	Иначе
		
		ПараметрыОтбора.Вставить("Характеристика", СтрокаДерева.ХарактеристикаМногооборотнаяТара);		
		ТараДокументаСтрокиСУпаковкой = ТоварыСУпаковкой.НайтиСтроки(ПараметрыОтбора);
		
	КонецЕсли;
	Если ТараДокументаСтрокиСУпаковкой.Количество()>0 Тогда
		ЕстьВыбраннаяУпаковка = Истина;
	КонецЕсли;

	Если ЕстьВыбраннаяУпаковка Тогда
		Если (СтрокаДерева.КоличествоТарыВДокументе <> СтрокаДерева.ПодобранноеКоличествоТары ИЛИ СтрокаДерева.ПодобранноеКоличествоТары =0)
		И (ТараДокументаСтрокиСУпаковкой[0].Упаковка = СтрокаДерева.Упаковка ИЛИ (СтрокаДерева.Родитель<>Неопределено И СтрокаДерева.Родитель.Выбрана = Истина)) Тогда
			СтрокаДерева.Выбрана = Истина;
			ВсяТараПодобрана = Ложь;
			Если СтрокаДерева.ПодобранноеКоличествоТары = 0 Тогда
				СтрокаДерева.ПодобранноеКоличествоТары = СтрокаДерева.КоличествоНоменклатуры;
			КонецЕсли;		
		КонецЕсли;
	ИначеЕсли (СтрокаДерева.КоличествоТарыВДокументе <> СтрокаДерева.ПодобранноеКоличествоТары)
		И (
		(СтрокаДерева.Родитель<>Неопределено И (СтрокаДерева.Родитель.Выбрана = Истина ИЛИ НЕ ЗначениеЗаполнено(СтрокаДерева.Родитель.НоменклатураМногооборотнаяТара)))
		ИЛИ СтрокаДерева.Родитель=Неопределено) Тогда
			СтрокаДерева.Выбрана = Истина;
			ВсяТараПодобрана = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьТаруВХранилище()
	
	ДеревоТара = РеквизитФормыВЗначение("Тара");
	
	ЕстьПодобраннаяТара = Ложь;
	
	ПроверитьДеревоНаНаличиеВыбранныхСтрок(ДеревоТара.Строки,ЕстьПодобраннаяТара);
	
	Если ЕстьПодобраннаяТара Тогда

		ТаблицаТары = Новый ТаблицаЗначений();
		ТаблицаТары.Колонки.Добавить("Номенклатура");
		ТаблицаТары.Колонки.Добавить("Характеристика");
		ТаблицаТары.Колонки.Добавить("Количество");
		ТаблицаТары.Колонки.Добавить("Склад");
		ТаблицаТары.Колонки.Добавить("Дата");
		
		ДобавитьПодобраннуюТаруВТаблицу(ДеревоТара.Строки, ТаблицаТары);
		
		ТаблицаТары.Свернуть("Номенклатура,Характеристика,Склад,Дата", "Количество");
		
		АдресМногооборотнойТарыВХранилище = ПоместитьВоВременноеХранилище(ТаблицаТары, УникальныйИдентификатор);
		Возврат АдресМногооборотнойТарыВХранилище;
	
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПроверитьДеревоНаНаличиеВыбранныхСтрок(СтрокиДерева,ЕстьПодобраннаяТара)
	
	Для Каждого ТекСтрока Из СтрокиДерева Цикл
		
		Если ЕстьПодобраннаяТара Тогда
			Прервать;
		КонецЕсли;
		
		Если ТекСтрока.Выбрана Тогда
			ЕстьПодобраннаяТара =  Истина;
			Прервать;
		КонецЕсли;
		
		ПроверитьДеревоНаНаличиеВыбранныхСтрок(ТекСтрока.Строки,ЕстьПодобраннаяТара)
		
	КонецЦикла;	
	
КонецФункции

&НаСервере
Процедура ДобавитьПодобраннуюТаруВТаблицу(СтрокиДерева, ТаблицаТары)
	
	Для Каждого ТекСтрока Из СтрокиДерева Цикл
		
		Если (ТекСтрока.Выбрана Или (Не ТекСтрока.Выбрана И ТекСтрока.КоличествоТарыВДокументе > 0))
			И ЗначениеЗаполнено(ТекСтрока.НоменклатураМногооборотнаяТара) Тогда
			
			НоваяСтрока = ТаблицаТары.Добавить();
			НоваяСтрока.Номенклатура = ТекСтрока.НоменклатураМногооборотнаяТара;
			НоваяСтрока.Характеристика = ТекСтрока.ХарактеристикаМногооборотнаяТара;
			НоваяСтрока.Количество = ?(ТекСтрока.Выбрана, ТекСтрока.ПодобранноеКоличествоТары, ТекСтрока.КоличествоТарыВДокументе);
			НоваяСтрока.Склад = ТекСтрока.Склад;
			НоваяСтрока.Дата = ТекСтрока.Дата;
			
		КонецЕсли;
		
		ДобавитьПодобраннуюТаруВТаблицу(ТекСтрока.Строки, ТаблицаТары);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТараВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ТараНоменклатура Тогда
		СтандартнаяОбработка = Ложь;
		Если ЗначениеЗаполнено(Элементы.Тара.ТекущиеДанные.Упаковка) Тогда
			ПоказатьЗначение(Неопределено, Элементы.Тара.ТекущиеДанные.Упаковка);
		Иначе
			ПоказатьЗначение(Неопределено, Элементы.Тара.ТекущиеДанные.Номенклатура);
		КонецЕсли;
	ИначеЕсли Поле = Элементы.ТараХарактеристика Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, Элементы.Тара.ТекущиеДанные.Характеристика);
	ИначеЕсли Поле = Элементы.ТараНоменклатураМногооборотнаяТара Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, Элементы.Тара.ТекущиеДанные.НоменклатураМногооборотнаяТара);
	ИначеЕсли Поле = Элементы.ТараХарактеристикаМногооборотнаяТара Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(Неопределено, Элементы.Тара.ТекущиеДанные.ХарактеристикаМногооборотнаяТара);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТараПриАктивизацииСтроки(Элемент)
	
	ОбновитьПредупреждающуюНадпись(Элементы, Элементы.Тара.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТараПодобранноеКоличествоТарыПриИзменении(Элемент)
	
	ОбновитьПредупреждающуюНадпись(Элементы, Элементы.Тара.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьТару(Команда)
	
    ЭлементыДерева = Тара.ПолучитьЭлементы();
    Для каждого ЭлементДерева Из ЭлементыДерева Цикл
        Элементы.Тара.Развернуть(ЭлементДерева.ПолучитьИдентификатор(),Истина);
    КонецЦикла;	
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьТару(Команда)
	
	ЭлементыДерева = Тара.ПолучитьЭлементы();
    Для каждого ЭлементДерева Из ЭлементыДерева Цикл
        Элементы.Тара.Свернуть(ЭлементДерева.ПолучитьИдентификатор());
    КонецЦикла;	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПредупреждающуюНадпись(Элементы, ТекущиеДанные = Неопределено)
	
	Если ТекущиеДанные <> Неопределено И
		((ТекущиеДанные.Выбрана И ТекущиеДанные.ПодобранноеКоличествоТары <> ТекущиеДанные.РекомендуемоеКоличествоТары)
		Или (Не ТекущиеДанные.Выбрана И ТекущиеДанные.КоличествоТарыВДокументе > 0 И
			ТекущиеДанные.КоличествоТарыВДокументе <> ТекущиеДанные.РекомендуемоеКоличествоТары)) Тогда
			
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаСПредупреждением;
		
	Иначе
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.СтраницаБезПредупреждения;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
