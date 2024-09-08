﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ИспользоватьУчетПрочихРасходов = ПолучитьФункциональнуюОпцию("ИспользоватьУчетПрочихДоходовРасходов");
	Если НЕ ИспользоватьУчетПрочихРасходов Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаСтр = Строка(ВалютаУправленческогоУчета);

	СтрокаЗаголовка = "%1 (%2)";
	ЗаголовокСумма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'Сумма расходов'"), ВалютаСтр);
	Элементы.ФинансовыйРезультатРасходыСуммаРасходов.Заголовок = ЗаголовокСумма;
	ЗаголовокСумма = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаЗаголовка, НСтр("ru = 'Сумма доходов'"), ВалютаСтр);
	Элементы.ФинансовыйРезультатДоходыСуммаДоходов.Заголовок = ЗаголовокСумма;
	
	ИспользуетсяНесколькоОрганизаций = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоОрганизаций");
	
	Если Не (ИспользуетсяНесколькоОрганизаций ИЛИ ЗначениеЗаполнено(Объект.Организация)) Тогда
		Объект.Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию();
	КонецЕсли;
	
	УстановитьЗаголовокЭтойФормы();
	УстановитьДоступностьКомандБуфераОбмена();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковОПродажахЗаПрошлыеПериоды.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обработчик механизма "ДатыЗапретаИзменения"
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПараметрыВыбораСтатейИАналитик = Документы.ВводОстатковОПродажахЗаПрошлыеПериоды.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПриЧтенииНаСервере(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
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

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "КопированиеСтрокВБуферОбмена" Тогда
		
		УстановитьДоступностьКомандБуфераОбменаНаКлиенте();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьЗаголовокЭтойФормы();
	ДоходыИРасходыСервер.ПослеЗаписиНаСервере(ЭтотОбъект);
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	ОрганизацияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
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
Процедура ВставитьСтроки(Команда)
	
	Если Элементы.ГруппаТипыОпераций.ТекущаяСтраница = Элементы.ГруппаФинансовыйРезультатРасходы Тогда
		КоличествоСтрокДоВставки = Объект.ФинансовыйРезультатРасходы.Количество();
		ПолучитьСтрокиИзБуфераОбмена(Элементы.ФинансовыйРезультатРасходы.Имя);
		КоличествоВставленных = Объект.ФинансовыйРезультатРасходы.Количество()-КоличествоСтрокДоВставки;
	Иначе
		КоличествоСтрокДоВставки = Объект.ФинансовыйРезультатДоходы.Количество();
		ПолучитьСтрокиИзБуфераОбмена(Элементы.ФинансовыйРезультатДоходы.Имя);
		КоличествоВставленных = Объект.ФинансовыйРезультатДоходы.Количество()-КоличествоСтрокДоВставки;
	КонецЕсли;
	РаботаСТабличнымиЧастямиКлиент.ОповеститьПользователяОВставкеСтрок(КоличествоВставленных);
	
КонецПроцедуры

&НаКлиенте
Процедура СкопироватьСтроки(Команда)
	
	Если Элементы.ГруппаТипыОпераций.ТекущаяСтраница = Элементы.ГруппаФинансовыйРезультатРасходы Тогда
		ТаблицаФормы = Элементы.ФинансовыйРезультатРасходы;
	Иначе
		ТаблицаФормы = Элементы.ФинансовыйРезультатДоходы;
	КонецЕсли;
	
	Если РаботаСТабличнымиЧастямиКлиент.ВыбранаСтрокаДляВыполненияКоманды(ТаблицаФормы) Тогда
		СкопироватьСтрокиНаСервере(ТаблицаФормы.Имя);
		РаботаСТабличнымиЧастямиКлиент.ОповеститьПользователяОКопированииСтрок(ТаблицаФормы.ВыделенныеСтроки.Количество());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(Элемент.Поля, Элементы.Подразделение.Имя);
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОтбор(Элемент.Отбор, "Объект.ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВводОстатковФинансовогоРезультатаЗаПрошлыеПериоды);

	Элемент.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗаголовокЭтойФормы()
	
	АвтоЗаголовок = Ложь;
	
	Заголовок = ВводОстатковВызовСервера.ЗаголовокДокументаВводОстатковПоХозяйственнойОперации(Объект.Ссылка,
		Объект.Номер,
		Объект.Дата,
		Объект.ХозяйственнаяОперация);
	
КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииСервер()

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ПараметрыУчетаПоОрганизации = УчетНДСУП.ПараметрыУчетаПоОрганизации(Объект.Организация, Объект.Дата);
		Объект.НалогообложениеНДС = ПараметрыУчетаПоОрганизации.ОсновноеНалогообложениеНДСПродажи;
	КонецЕсли;

КонецПроцедуры

#Область РаботаСБуферомОбмена

&НаСервере
Процедура СкопироватьСтрокиНаСервере(ИмяТаблицыФормы)
	
	ТабличнаяЧасть = ?(ИмяТаблицыФормы = Элементы.ФинансовыйРезультатРасходы.Имя, Объект.ФинансовыйРезультатРасходы,
		Объект.ФинансовыйРезультатДоходы);
	
	РаботаСТабличнымиЧастями.СкопироватьСтрокиВБуферОбмена(ТабличнаяЧасть, Элементы[ИмяТаблицыФормы].ВыделенныеСтроки);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьСтрокиИзБуфераОбмена(ИмяТаблицыФормы)
	
	Если ИмяТаблицыФормы = Элементы.ФинансовыйРезультатРасходы.Имя Тогда
		Колонки = "НаправлениеДеятельности, СтатьяРасходов, СуммаРасходов, ДатаОтражения";
		ТабличнаяЧасть = Объект.ФинансовыйРезультатРасходы;
	Иначе
		Колонки = "НаправлениеДеятельности, СтатьяДоходов, СуммаДоходов, ДатаОтражения";
		ТабличнаяЧасть = Объект.ФинансовыйРезультатДоходы;
	КонецЕсли;
	
	ТаблицаСтрок = РаботаСТабличнымиЧастями.СтрокиИзБуфераОбмена(, Колонки);
	
	Если Не ЗначениеЗаполнено(ТаблицаСтрок) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Строка Из ТаблицаСтрок Цикл
		ТекущаяСтрока = ТабличнаяЧасть.Добавить();
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока, Строка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьКомандБуфераОбмена()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ФинансовыйРезультатРасходыВставитьСтроки");
	МассивЭлементов.Добавить("ФинансовыйРезультатДоходыВставитьСтроки");
	МассивЭлементов.Добавить("ФинансовыйРезультатРасходыКонтекстноеМенюВставитьСтроки");
	МассивЭлементов.Добавить("ФинансовыйРезультатДоходыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность",
		РаботаСТабличнымиЧастями.ЕстьСтрокиВБуфереОбмена());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКомандБуфераОбменаНаКлиенте()
	
	МассивЭлементов = Новый Массив();
	МассивЭлементов.Добавить("ФинансовыйРезультатРасходыВставитьСтроки");
	МассивЭлементов.Добавить("ФинансовыйРезультатДоходыВставитьСтроки");
	МассивЭлементов.Добавить("ФинансовыйРезультатРасходыКонтекстноеМенюВставитьСтроки");
	МассивЭлементов.Добавить("ФинансовыйРезультатДоходыКонтекстноеМенюВставитьСтроки");
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы, МассивЭлементов, "Доступность", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ФинансовыйРезультатРасходыСтатьяРасходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ФинансовыйРезультатРасходыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	СтрокаТаблицы = Элементы.ФинансовыйРезультатРасходы.ТекущиеДанные;
	ДоходыИРасходыКлиентСервер.ПриДобавленииСтрокиВТаблицу(ЭтотОбъект, СтрокаТаблицы, "Объект.ФинансовыйРезультатРасходы");
КонецПроцедуры

&НаКлиенте
Процедура ФинансовыйРезультатДоходыСтатьяДоходовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ДоходыИРасходыКлиент.НачалоВыбораСтатьи(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура ФинансовыйРезультатДоходыСтатьяДоходовПриИзменении(Элемент)
	ДоходыИРасходыКлиентСервер.СтатьяПриИзменении(ЭтотОбъект, Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти
