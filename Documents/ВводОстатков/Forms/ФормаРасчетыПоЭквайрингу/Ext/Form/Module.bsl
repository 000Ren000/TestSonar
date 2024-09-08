﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();

	Элементы.ГруппаВводОстатковПо.Видимость = Ложь;
	Элементы.ОтражатьВБУиНУ.Видимость       = Ложь;
	Элементы.ОтражатьВУУ.Видимость          = Ложь;

	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	ИспользоватьНесколькоВалют = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют");
	УстановитьЗаголовок();
	
	ИсправлениеДокументов.ПриСозданииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИсправлениеДокументов.ПриЧтенииНаСервере(ЭтаФорма, Элементы.СтрокаИсправление);
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	ПриЧтенииСозданииНаСервере();

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументовКлиент.ПослеЗаписи(Объект);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовок();
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИсправлениеДокументовКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#Область ОбработчикиКоммандФормы

&НаКлиенте
Процедура ЗаполнитьПоДаннымОтчетовЭквайринга(Команда)
	
	Если Объект.РасчетыПоЭквайрингу.Количество() > 0 Тогда
		
		ТекстВопроса = НСтр("ru='Перед выполнением операции табличная часть будет очищена. Продолжить?'");
		
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоДаннымОтчетовЭквайрингаЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Да);
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьПоДаннымОтчетовЭквайрингаФрагмент();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымОтчетовЭквайрингаЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    
    ЗаполнитьПоДаннымОтчетовЭквайрингаФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымОтчетовЭквайрингаФрагмент()
    
    ЗаполнитьПоДаннымОтчетовЭквайрингаСервер();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВОперативномУчетеПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБУиНУПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВУУПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыРасчетыПоЭквайрингу

&НаСервере
Процедура РассчитатьСуммы(Сумма, СуммаРегл, СуммаУпр, ДоговорЭквайринга)
	
	ДатаДокумента = Объект.Дата;
	
	Валюта = Справочники.ДоговорыЭквайринга.РеквизитыДоговора(ДоговорЭквайринга).Валюта;
	Если Валюта = ВалютаРегламентированногоУчета Тогда
		СуммаРегл = Сумма;
	Иначе
		КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаРегламентированногоУчета, ДатаДокумента);
		СуммаРегл = Окр(Сумма * КоэффициентПересчета, 2, 1);
	КонецЕсли;
	Если Валюта = ВалютаУправленческогоУчета Тогда
		СуммаУпр = Сумма;
	Иначе
		КоэффициентПересчета = РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(Валюта, ВалютаУправленческогоУчета, ДатаДокумента);
		СуммаУпр = Окр(Сумма * КоэффициентПересчета, 2, 1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииРеквизита()
	
	ТекущаяСтрока = Элементы.РасчетыПоЭквайрингу.ТекущиеДанные;

	Если Не ИспользоватьНесколькоВалют Тогда
		ТекущаяСтрока.Валюта = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	РассчитатьСуммы(
		ТекущаяСтрока.Сумма, 
		ТекущаяСтрока.СуммаРегл, 
		ТекущаяСтрока.СуммаУпр, 
		ТекущаяСтрока.ДоговорЭквайринга); 
		
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоЭквайрингуДоговорЭквайрингаПриИзменении(Элемент)
	
	ПриИзмененииРеквизита();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоЭквайрингуЭквайринговыйТерминалПриИзменении(Элемент)
	
	ПриИзмененииРеквизита();
	
КонецПроцедуры

&НаКлиенте
Процедура РасчетыПоЭквайрингуСуммаПриИзменении(Элемент)
	
	ПриИзмененииРеквизита();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	УстановитьВидимость();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.РасчетыПоЭквайрингуСуммаРегл.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВБУиНУ;
	Элементы.РасчетыПоЭквайрингуСуммаУпр.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВУУ;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
		Объект.Номер,
		Объект.Дата,
		Объект.ХозяйственнаяОперация);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымОтчетовЭквайрингаСервер()
	
	ТекОбъект = РеквизитФормыВЗначение("Объект");
	ТекОбъект.ЗаполнитьДанныеЭквайринга();
	ЗначениеВРеквизитФормы(ТекОбъект, "Объект");
	
КонецПроцедуры

#КонецОбласти
