﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ИспользуетсяНесколькоСчетов = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	
	Элементы.ГруппаВводОстатковПо.Видимость  = Ложь;
	Элементы.ОтражатьВБУиНУ.Видимость        = Ложь;
	Элементы.ОтражатьВУУ.Видимость           = Ложь;

	
	УстановитьЗаголовок();
	
	Если НЕ (ИспользуетсяНесколькоСчетов ИЛИ ВозможностьОткрытияДокументаОтУстановленныхФО()) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ИспользуетсяНесколькоСчетов Тогда
		ЕдинственныйСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию();
		ВалютаСчета = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЕдинственныйСчет, "ВалютаДенежныхСредств");
		Если Объект.БанковскиеСчета.Количество() > 0 Тогда
			ОстатокНаСчете = Объект.БанковскиеСчета[0].Сумма;
		КонецЕсли;
	КонецЕсли;
	УстановитьВидимость();

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
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не ИспользуетсяНесколькоСчетов Тогда
		Если НЕ ЗначениеЗаполнено(ЕдинственныйСчет) Тогда
			ПодробноеПредставлениеОшибки =
				НСтр("ru = 'В информационной базе используется один банковский счет,
				|но его свойства не настроены разделе ""Казначейство"" - ""Настройки и справочники"" - ""Настройка банковского счета"".'")
			;
			Отказ = Истина;
			ВызватьИсключение ПодробноеПредставлениеОшибки;
		КонецЕсли;
		Объект.БанковскиеСчета.Очистить();
		НоваяСтрока = Объект.БанковскиеСчета.Добавить();
		НоваяСтрока.БанковскийСчет = ЕдинственныйСчет;
		НоваяСтрока.Сумма = ОстатокНаСчете;
		ПриИзмененииРеквизитаСервер(
			НоваяСтрока.Сумма, 
			НоваяСтрока.СуммаРегл,
			НоваяСтрока.СуммаУпр,
			НоваяСтрока.БанковскийСчет);
	КонецЕсли;
	
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
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИсправлениеДокументовКлиент.ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

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
Процедура ОрганизацияПриИзменении(Элемент)
	ОрганизацияПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Объект.Организация);
КонецПроцедуры

&НаКлиенте
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовПодвалаФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыБанковскиеСчета

&НаКлиенте
Процедура БанковскиеСчетаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока И НЕ ИспользуетсяНесколькоСчетов Тогда
	
		Элемент.ТекущиеДанные.БанковскийСчет = ЕдинственныйСчет;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскиеСчетаБанковскийСчетПриИзменении(Элемент)
	
	ПриИзмененииРеквизита();
	
КонецПроцедуры

&НаКлиенте
Процедура БанковскиеСчетаСуммаПриИзменении(Элемент)
	
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

&НаКлиенте
Процедура ЗаполнитьПоОстаткам(Команда)
	Возврат;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьЗаголовок()
	
	АвтоЗаголовок = Ложь;
	Заголовок = Документы.ВводОстатков.ЗаголовокДокументаПоТипуОперации(Объект.Ссылка,
																						  Объект.Номер,
																						  Объект.Дата,
																						  Объект.ХозяйственнаяОперация);
	
КонецПроцедуры

&НаСервере
Процедура ПриИзмененииРеквизитаСервер(Сумма, СуммаРегл, СуммаУпр, БанковскийСчет)
	
	ДатаДокумента = Объект.Дата;
	
	Валюта = Справочники.БанковскиеСчетаОрганизаций.ПолучитьРеквизитыБанковскогоСчетаОрганизации(БанковскийСчет).Валюта;
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
	
	СтрокаТаблицы = Элементы.БанковскиеСчета.ТекущиеДанные;
	ПриИзмененииРеквизитаСервер(
		СтрокаТаблицы.Сумма, 
		СтрокаТаблицы.СуммаРегл,
		СтрокаТаблицы.СуммаУпр,
		СтрокаТаблицы.БанковскийСчет);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимость()
	
	Элементы.ГруппаОдинСчет.Видимость = Не ИспользуетсяНесколькоСчетов;
	Элементы.ГруппаБанковскиеСчета.Видимость = ИспользуетсяНесколькоСчетов;
	Элементы.БанковскиеСчетаЗаполнитьПоОстаткам.Видимость = 
		НЕ Объект.ОтражатьВОперативномУчете И (Объект.ОтражатьВБУиНУ ИЛИ Объект.ОтражатьВУУ);
	Элементы.БанковскиеСчетаСуммаРегл.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВБУиНУ;
	Элементы.БанковскиеСчетаСуммаУпр.Видимость = Объект.ОтражатьВОперативномУчете ИЛИ Объект.ОтражатьВУУ;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВозможностьОткрытияДокументаОтУстановленныхФО()
	
	Результат = Истина;
	
	БанковскийСчет = ЗначениеНастроекПовтИсп.ПолучитьБанковскийСчетОрганизацииПоУмолчанию();
	Если Не ЗначениеЗаполнено(БанковскийСчет) Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
		|	БанковскиеСчетаОрганизаций.Ссылка
		|ИЗ
		|	Справочник.БанковскиеСчетаОрганизаций КАК БанковскиеСчетаОрганизаций");
		
		Если Запрос.Выполнить().Выбрать().Количество() = 2 Тогда
			ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Банковский счет"". В информационной базе введено несколько банковских счетов организаций,
			|Включите функциональную опцию ""Использовать несколько банковских счетов""!'");
		Иначе
			ВызватьИсключение НСтр("ru = 'Не удалось заполнить поле ""Банковский счет"". Возможно, в информационной базе не введено ни одного банковского счета организации!'");
		КонецЕсли;
		Результат = Ложь;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции


#КонецОбласти
