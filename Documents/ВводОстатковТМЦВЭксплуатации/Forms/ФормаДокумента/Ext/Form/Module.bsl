﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьРеглУчет = ПолучитьФункциональнуюОпцию("ИспользоватьРеглУчет");
	Элементы.ГруппаВводОстатковПо.Видимость = ИспользоватьРеглУчет;
	
	УправлениеТорговлей = ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	ИспользоватьУчетПрослеживаемыхТоваров = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрослеживаемыхИмпортныхТоваров");
	Элементы.ТМЦВЭксплуатацииНомерГТД.Видимость = ИспользоватьУчетПрослеживаемыхТоваров И НЕ УправлениеТорговлей;
	Элементы.ТМЦВЭксплуатацииКоличествоПоРНПТ.Видимость = ИспользоватьУчетПрослеживаемыхТоваров И НЕ УправлениеТорговлей;
	
	УчетПрослеживаемыхТоваровЛокализация.УстановитьЗаголовокНомерГТД(Элементы, 
		Элементы.ТМЦВЭксплуатацииНомерГТД.Имя);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковТМЦВЭксплуатации.ПараметрыВыбораСтатейИАналитик(Объект.Дата);
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументов.ПриСозданииНаСервере(ЭтотОбъект, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковТМЦВЭксплуатации.ПараметрыВыбораСтатейИАналитик(Объект.Дата);
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	ПриЧтенииСозданииНаСервере();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ИсправлениеДокументов.ПриЧтенииНаСервере(ЭтотОбъект, Элементы.СтрокаИсправление);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ХозяйственнаяОперация", Объект.ХозяйственнаяОперация);
	Оповестить("Запись_ВводОстатков", ПараметрыЗаписи, Объект.Ссылка);
	ОбщегоНазначенияУТКлиент.ОповеститьОЗаписиДокументаВЖурнал();
	ИсправлениеДокументовКлиент.ПослеЗаписи(Объект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
	ЗаполнитьСлужебныеРеквизитыТЧ();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ИсправлениеДокументовКлиент.ОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтотОбъект, ПараметрыУказанияСерий, ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПриИзмененииНаСервере();

КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	СтоимостьСписана = СтоимостьСписана(Объект.Организация, Объект.Дата);
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, Элемент.Имя);

КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаИсправлениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ИсправлениеДокументовКлиент.СтрокаИсправлениеОбработкаНавигационныйСсылки(
		ЭтотОбъект, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТМЦВЭксплуатации

&НаКлиенте
Процедура ТМЦВЭксплуатацииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущиеДанные = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;

	Если НоваяСтрока Тогда

		ТекущиеДанные.ИнвентарныйНомер = "";
			
	КонецЕсли;
	
	ДоходыИРасходыКлиентСервер.ПриДобавленииСтрокиВТаблицу(ЭтотОбъект, ТекущиеДанные, "Объект.ТМЦВЭксплуатации");
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
	
	СтруктураДействий = Новый Структура;
	ДобавитьДействияПриИзмененииНоменклатуры(СтруктураДействий, ЭтотОбъект, ТекущаяСтрока);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииКатегорияЭксплуатацииПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;

	ПриИзмененииКатегорииЭксплуатации(ТекущаяСтрока);
	
	ТМЦВЭксплуатацииКлиент.ОбработатьСтрокуПриИзмененииКатегорииЭксплуатации(
		ТекущаяСтрока, Объект.ТМЦВЭксплуатации,, "Количество");
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииСтатьяРасходовПриИзменении(Элемент)
	
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииСтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииАналитикаРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораАналитикиРасходов(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииАналитикаРасходовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.АвтоПодборАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииАналитикаРасходовПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.АналитикаРасходовПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииАналитикаРасходовОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.ОкончаниеВводаТекстаАналитикиРасходов(ЭтотОбъект, Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииСерияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТМЦВЭксплуатации.ТекущиеДанные;
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	
	ВыбранноеЗначение.Значение = ТекущаяСтрока.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтотОбъект, ПараметрыУказанияСерий, ВыбранноеЗначение);

КонецПроцедуры

&НаКлиенте
Процедура ТМЦВЭксплуатацииСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УказатьСерии(Команда)
	
	ОткрытьПодборСерий();

КонецПроцедуры

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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПриИзмененииРеквизитов

&НаСервере
Процедура ДатаПриИзмененииНаСервере()
	
	СтоимостьСписана = СтоимостьСписана(Объект.Организация, Объект.Дата);

	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковТМЦВЭксплуатации.ПараметрыВыбораСтатейИАналитик(Объект.Дата);
	ДоходыИРасходыСервер.ПриИзмененииПараметровВыбораСтатей(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);

	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект, "Дата");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииКатегорииЭксплуатации(ТекущаяСтрока)
	
	СтруктураДействий = Новый Структура;
	
	ПараметрыЗаполнения = ТМЦВЭксплуатацииКлиентСервер.ПараметрыЗаполненияПризнаковКатегорииЭксплуатации();
	СтруктураДействий.Вставить("ЗаполнитьПризнакиКатегорииЭксплуатации", ПараметрыЗаполнения);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Если НЕ ТекущаяСтрока.УчетПоФизЛицам Тогда
		ТекущаяСтрока.ФизическоеЛицо = ПредопределенноеЗначение("Справочник.ФизическиеЛица.ПустаяСсылка");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(
		ЭтотОбъект,
		"ТМЦВЭксплуатацииХарактеристика",
		"Объект.ТМЦВЭксплуатации.ХарактеристикиИспользуются");
	
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(
		ЭтотОбъект, 
		"СерииВсегдаВТЧТовары",
		"ТМЦВЭксплуатацииСерия",
		"Объект.ТМЦВЭксплуатации.СтатусУказанияСерий",
		"Объект.ТМЦВЭксплуатации.ТипНоменклатуры");
		
	НоменклатураСервер.УстановитьУсловноеОформлениеСтатусовУказанияСерий(
		ЭтотОбъект, 
		Истина,
		"ТМЦВЭксплуатацииСтатусУказанияСерий",
		"Объект.ТМЦВЭксплуатации.СтатусУказанияСерий");
	
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ТекущаяДатаСеанса = ТекущаяДатаСеанса();
	
	
	СтоимостьСписана = СтоимостьСписана(Объект.Организация, Объект.Дата);
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.ВводОстатковТМЦВЭксплуатации));

	УстановитьВидимостьЭлементовСерий();
	ЗаполнитьСлужебныеРеквизитыТЧ();
	
	НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормыНаКлиентеНаСервере(Форма, ИзмененныеРеквизиты = "")
	
	Объект = Форма.Объект;

	СтруктураИзмененныхРеквизитов = Новый Структура(ИзмененныеРеквизиты);
	ОбновитьВсе = СтруктураИзмененныхРеквизитов.Количество() = 0;

	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("СтоимостьСписана", Форма.СтоимостьСписана);
	ПараметрыРеквизитовОбъекта = ТМЦВЭксплуатацииКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_ВводОстатковТМЦВЭксплуатации(
									Объект, ДопПараметры, ИзмененныеРеквизиты);
									
	ОбщегоНазначенияУТКлиентСервер.НастроитьЗависимыеЭлементыФормы(Форма, ПараметрыРеквизитовОбъекта);
	
	Если НЕ ОбновитьВсе Тогда
		ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(Объект, ПараметрыРеквизитовОбъекта, "ТМЦВЭксплуатации");
	КонецЕсли;
		
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыТЧ()

	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.ТМЦВЭксплуатации, ПараметрыЗаполненияРеквизитов);
	

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено)

	Если НЕ НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтотОбъект, ПараметрыУказанияСерий, Текст, ТекущиеДанные) Тогда
		Возврат;
	КонецЕсли;
		
	Если ТекущиеДанные = Неопределено Тогда
		ТекущиеДанныеИдентификатор = Элементы.ТМЦВЭксплуатации.ТекущиеДанные.ПолучитьИдентификатор();
	Иначе
		ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
	КонецЕсли;

	ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
	
	ДопПараметры = Новый Структура("ПараметрыФормыУказанияСерий", ПараметрыФормыУказанияСерий);
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение", ЭтотОбъект, ДопПараметры);
	
	ОткрытьФорму(
		ПараметрыФормыУказанияСерий.ИмяФормы,
		ПараметрыФормыУказанияСерий,
		ЭтотОбъект,,,, 
		ОписаниеОповещения, 
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    Если Результат <> Неопределено Тогда
        ОбработатьУказаниеСерийСервер(ДополнительныеПараметры.ПараметрыФормыУказанияСерий);
    КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий)
		
	НоменклатураСервер.ОбработатьУказаниеСерий(Объект, ПараметрыУказанияСерий, ПараметрыФормыУказанияСерий);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДобавитьДействияПриИзмененииНоменклатуры(СтруктураДействий, Форма, ТекущаяСтрока)
	
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу", ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", Новый Структура("Номенклатура", "ХарактеристикиИспользуются"));
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры", Новый Структура("Номенклатура", "ТипНоменклатуры"));
	
	ПроверитьСериюРассчитатьСтатус = Новый Структура("ПараметрыУказанияСерий, Склад", Форма.ПараметрыУказанияСерий, Неопределено);
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПроверитьСериюРассчитатьСтатус);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий, ТекущиеДанныеИдентификатор, ЭтотОбъект);
	
КонецФункции

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Элементы.ТМЦВЭксплуатацииСтатусУказанияСерий.Видимость = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	Элементы.ТМЦВЭксплуатацииУказатьСерии.Видимость = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	Элементы.ТМЦВЭксплуатацииСерия.Видимость = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтоимостьСписана(Организация, Дата)
	
	СтоимостьСписана = Истина;
	
	
	Возврат СтоимостьСписана;
	
КонецФункции

#КонецОбласти

#КонецОбласти