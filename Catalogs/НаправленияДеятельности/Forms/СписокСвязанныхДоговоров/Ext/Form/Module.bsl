﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	СформироватьВыборкуДанныхСписка();
	
	Если Параметры.Отбор.Свойство("НаправлениеДеятельности") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "НаправлениеДеятельностиОтбор", Параметры.Отбор.НаправлениеДеятельности);
	КонецЕсли;
	
	Настройки = Список.КомпоновщикНастроек.Настройки;
	ПолеСсылка = Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("Ссылка"));
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПараметрРазмещения = ПодключаемыеКоманды.ПараметрыРазмещения();
	ПараметрРазмещения.Источники = ПолеСсылка.Тип;
	ПараметрРазмещения.КоманднаяПанель = Элементы.СписокКоманднаяПанель;
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект, ПараметрРазмещения);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДокументов

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ПоказатьЗначение(, ВыбраннаяСтрока);

КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииПоля(Элемент)

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьВыборкуДанныхСписка()

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДоговорыКонтрагентов.Ссылка КАК Ссылка,
	|	&ТекстДоговорКонтрагента КАК ТипДоговора,
	|	ДоговорыКонтрагентов.ПометкаУдаления КАК ПометкаУдаления,
	|	ДоговорыКонтрагентов.Согласован КАК Согласован,
	|	ДоговорыКонтрагентов.Статус КАК Статус,
	|	ДоговорыКонтрагентов.Организация КАК Организация,
	|	ДоговорыКонтрагентов.Номер КАК Номер,
	|	ДоговорыКонтрагентов.НаименованиеДляПечати КАК НаименованиеДляПечати,
	|	ДоговорыКонтрагентов.ДатаНачалаДействия КАК ДатаНачалаДействия,
	|	ДоговорыКонтрагентов.ДатаОкончанияДействия КАК ДатаОкончанияДействия,
	|	ДоговорыКонтрагентов.ВалютаВзаиморасчетов КАК ВалютаВзаиморасчетов
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.НаправлениеДеятельности = &НаправлениеДеятельностиОтбор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорыКредитовИДепозитов.Ссылка,
	|	&ТекстДоговорКредитовДепозитов,
	|	ДоговорыКредитовИДепозитов.ПометкаУдаления,
	|	ДоговорыКредитовИДепозитов.Согласован,
	|	ДоговорыКредитовИДепозитов.Статус,
	|	ДоговорыКредитовИДепозитов.Организация,
	|	ДоговорыКредитовИДепозитов.Номер,
	|	ДоговорыКредитовИДепозитов.НаименованиеДляПечати,
	|	NULL,
	|	NULL,
	|	ДоговорыКредитовИДепозитов.ВалютаВзаиморасчетов
	|ИЗ
	|	Справочник.ДоговорыКредитовИДепозитов КАК ДоговорыКредитовИДепозитов
	|ГДЕ
	|	ДоговорыКредитовИДепозитов.НаправлениеДеятельности = &НаправлениеДеятельностиОтбор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорыМеждуОрганизациями.Ссылка,
	|	&ТекстДоговорМеждуОрганизациями,
	|	ДоговорыМеждуОрганизациями.ПометкаУдаления,
	|	ДоговорыМеждуОрганизациями.Согласован,
	|	ДоговорыМеждуОрганизациями.Статус,
	|	ДоговорыМеждуОрганизациями.Организация,
	|	ДоговорыМеждуОрганизациями.Номер,
	|	ДоговорыМеждуОрганизациями.НаименованиеДляПечати,
	|	ДоговорыМеждуОрганизациями.ДатаНачалаДействия,
	|	ДоговорыМеждуОрганизациями.ДатаОкончанияДействия,
	|	ДоговорыМеждуОрганизациями.ВалютаВзаиморасчетов
	|ИЗ
	|	Справочник.ДоговорыМеждуОрганизациями КАК ДоговорыМеждуОрганизациями
	|ГДЕ
	|	ДоговорыМеждуОрганизациями.НаправлениеДеятельности = &НаправлениеДеятельностиОтбор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ДоговорыЭквайринга.Ссылка,
	|	&ТекстДоговорЭквайринга,
	|	ДоговорыЭквайринга.ПометкаУдаления,
	|	ДоговорыЭквайринга.Согласован,
	|	ДоговорыЭквайринга.Статус,
	|	ДоговорыЭквайринга.Организация,
	|	ДоговорыЭквайринга.Номер,
	|	ДоговорыЭквайринга.Наименование,
	|	NULL,
	|	NULL,
	|	NULL
	|ИЗ
	|	Справочник.ДоговорыЭквайринга КАК ДоговорыЭквайринга
	|ГДЕ
	|	ДоговорыЭквайринга.НаправлениеДеятельности = &НаправлениеДеятельностиОтбор
	|
	|";
	
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "Справочник.ДоговорыКонтрагентов", "(" + ТекстЗапроса + ")");
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекстДоговорКонтрагента", НСтр("ru = 'Договор контрагента'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекстДоговорКредитовДепозитов", НСтр("ru = 'Договор кредитов и депозитов'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекстДоговорМеждуОрганизациями", НСтр("ru = 'Договор между организациями'"));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекстДоговорЭквайринга", НСтр("ru = 'Договор подключения к платежной системе'"));

КонецПроцедуры

#КонецОбласти