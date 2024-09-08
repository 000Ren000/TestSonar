﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ТекущиеДанныеИдентификатор; //используется для передачи текущей строки в обработчик ожидания

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ.

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
		
	УстановитьУсловноеОформление();
	
	Элементы.ГруппаПанельОтправки.Видимость = НЕ ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	Элементы.Отправка.Видимость = НЕ ПолучитьФункциональнуюОпцию("УправлениеТорговлей");
	
	ЗаполнитьВременныеРеквизиты();
	УстановитьПараметрыВыбораНоменклатуры();
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
		НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	КонецЕсли;

	
	ПрослеживаемостьСобытияФормПереопределяемый.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	ЗаполнитьПредставлениеМестаХранения();
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.УведомлениеОВвозеПрослеживаемыхТоваров));
	УстановитьВидимостьЭлементовСерий();
	УстановитьВидимостьБлокаСостоянияОтправки();
	РаботаСТабличнымиЧастями.ИнициализироватьКэшСтрок(Элементы.Товары);
	
	ПодготовитьЗаполнитьУстановитьВидимостьСерий();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСлужебныеРеквизитыПоНоменклатуре()
	
	ЗаполнитьПризнакАртикул						= Новый Структура("Номенклатура", "Артикул");
	ЗаполнитьПризнакТипНоменклатуры				= Новый Структура("Номенклатура", "ТипНоменклатуры");
	ЗаполнитьПризнакХарактеристикиИспользуются	= Новый Структура("Номенклатура", "ХарактеристикиИспользуются");
	ЗаполнитьПризнакВедетсяУчетПоГТД			= Новый Структура("Номенклатура", "ВедетсяУчетПоГТД");
	
	ПараметрыЗаполненияРеквизитов = Новый Структура;
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакАртикул",			ЗаполнитьПризнакАртикул);
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакТипНоменклатуры",	ЗаполнитьПризнакТипНоменклатуры);
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются",
											ЗаполнитьПризнакХарактеристикиИспользуются);
	ПараметрыЗаполненияРеквизитов.Вставить("ЗаполнитьПризнакВедетсяУчетПоГТД",	ЗаполнитьПризнакВедетсяУчетПоГТД);
	
	УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ДополнитьОписаниеНастроекЗаполненияСлужебныхРеквизитовТабличнойЧасти(
		ПараметрыЗаполненияРеквизитов);
	
	НоменклатураСервер.ЗаполнитьСлужебныеРеквизитыПоНоменклатуреВКоллекции(Объект.Товары, ПараметрыЗаполненияРеквизитов);
	
КонецПроцедуры

&НаКлиенте
Процедура РНПТПриИзменении(Элемент)
	
	Для Каждого Строка Из Объект.Товары Цикл
		Строка.НомерГТД = Неопределено;
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьПредставлениеМестаХранения()
	
	Товары = Объект.Товары;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Товары.НомерСтроки	КАК НомерСтроки,
	|	ВЫБОР
	|		КОГДА Товары.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Склад)
	|			ТОГДА Товары.Склад
	|		КОГДА Товары.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.Подразделение)
	|			ТОГДА Товары.Подразделение
	|		КОГДА Товары.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
	|			ТОГДА Товары.Договор
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ				КАК МестоХранения,
	|	ВЫБОР
	|		КОГДА Товары.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
	|			ТОГДА Товары.Хранитель
	|		ИНАЧЕ """"
	|	КОНЕЦ				КАК ПрефиксМестоХранения,
	|	ВЫБОР
	|		КОГДА Товары.ТипМестаХранения = ЗНАЧЕНИЕ(Перечисление.ТипыМестХранения.ДоговорКонтрагента)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ				КАК МестоХраненияДоговор
	|ПОМЕСТИТЬ ТоварыДляЗапроса
	|ИЗ
	|	&ТоварыДокумента КАК Товары
	|
	|;
	|/////////////////////////////////////////////////////////////////// 1
	|ВЫБРАТЬ
	|	Товары.НомерСтроки							КАК НомерСтроки,
	|	Товары.МестоХранения						КАК МестоХранения,
	|	ПРЕДСТАВЛЕНИЕ(Товары.МестоХранения)			КАК ПредставлениеМестаХранения,
	|	ПРЕДСТАВЛЕНИЕ(Товары.ПрефиксМестоХранения)	КАК ПредставлениеПрефиксМестаХранения
	|ИЗ
	|	ТоварыДляЗапроса КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК Договоры
	|		ПО Товары.МестоХраненияДоговор
	|			И Товары.МестоХранения = Договоры.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("ТоварыДокумента", Товары.Выгрузить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Для НомерСтроки = 0 По Товары.Количество() - 1 Цикл
		Выборка.Следующий();
		
		Товары[НомерСтроки].ПредставлениеМестаХранения = ПредставлениеМестаХранения(Выборка.ПредставлениеМестаХранения,
																					Выборка.ПредставлениеПрефиксМестаХранения);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеМестаХранения(Представление, ПредставлениеПрефикс)
	
	ШаблонРасширенногоПредставления = НСтр("ru = '%1, %2'");
	
	РасширенноеПредставление	= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонРасширенногоПредставления,
																						ПредставлениеПрефикс,
																						Представление);
	ПредставлениеМестаХранения	= ?(ПустаяСтрока(ПредставлениеПрефикс),
									Представление,
									РасширенноеПредставление);
	
	Возврат ПредставлениеМестаХранения;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ПодготовитьФормуНаСервере();
	
	ПрослеживаемостьСобытияФормПереопределяемый.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	
	ПриЧтенииСозданииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПрослеживаемостьСобытияФормКлиентПереопределяемый.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_УведомлениеОВвозеПрослеживаемыхТоваров", ПараметрыЗаписи, Объект.Ссылка);
	
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
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	Если Не ПараметрыЗаписи.Свойство("ПервичныйДокумент") Тогда
		ПараметрыЗаписи.Вставить("ПервичныйДокумент", ТекущийОбъект.ПервичныйДокумент);
	КонецЕсли;

	УстановитьСостояниеДокумента();
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	ЗаполнитьПредставлениеМестаХранения();
	
	ПрослеживаемостьСобытияФормПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗаполнитьРНПТ(Команда)
	
	Сообщение = Новый СообщениеПользователю;	
	Сообщение.Текст = НСтр("ru='Функционал не реализован.'");
	Сообщение.Сообщить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПервичныйДокументПриИзменении(Элемент)
	
	ОчиститьТабличнуюЧастьПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КодТНВЭДПриИзменении(Элемент)
	
	КодТНВЭДПриИзмененииНаСервере();
	ОчиститьТабличнуюЧастьПриИзмененииРеквизита(Элемент);
	УстановитьПараметрыВыбораНоменклатуры();
		
КонецПроцедуры

&НаКлиенте
Процедура ЕдиницаИзмеренияПриИзменении(Элемент)
		
	ОчиститьТабличнуюЧастьПриИзмененииРеквизита(Элемент);
	УстановитьПараметрыВыбораНоменклатуры();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыВыбораНоменклатуры()
	
	НовыйМассив = Новый Массив();
	Если ЗначениеЗаполнено(Объект.КодТНВЭД) Тогда
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.КодТНВЭД", Объект.КодТНВЭД));
	КонецЕсли;
	Если ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) Тогда
		НовыйМассив.Добавить(Новый ПараметрВыбора("Отбор.ЕдиницаИзмерения", Объект.ЕдиницаИзмерения));
	КонецЕсли;
	Элементы.ТоварыНоменклатура.ПараметрыВыбора = Новый ФиксированныйМассив(НовыйМассив);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТовары

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	Иначе
		ПрослеживаемостьФормыКлиент.ОбработкаВыбораУведомления(ЭтотОбъект, ВыбранноеЗначение, ИсточникВыбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьПризнакАртикул						= Новый Структура("Номенклатура", "Артикул");
	ЗаполнитьПризнакТипНоменклатуры				= Новый Структура("Номенклатура", "ТипНоменклатуры");
	ПроверитьСериюРассчитатьСтатус				= Новый Структура("Склад, ПараметрыУказанияСерий",
															ТекущаяСтрока.Склад, ПараметрыУказанияСерий);
	ЗаполнитьПризнакВедетсяУчетПоГТД			= Новый Структура("Номенклатура", "ВедетсяУчетПоГТД");
	НоменклатураПриИзмененииПереопределяемый	= Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
																	ИмяФормы, "Товары");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул",					ЗаполнитьПризнакАртикул);
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры",			ЗаполнитьПризнакТипНоменклатуры);
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",		ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус",			ПроверитьСериюРассчитатьСтатус);
	СтруктураДействий.Вставить("ЗаполнитьПризнакВедетсяУчетПоГТД",			ЗаполнитьПризнакВедетсяУчетПоГТД);
	СтруктураДействий.Вставить("ЗаполнитьСтрануПроисхожденияНоменклатуры",
								ОбработкаТабличнойЧастиКлиентСервер.ПараметрыЗаполненияСтраныПроисхождения());
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый",	НоменклатураПриИзмененииПереопределяемый);
	
	ЗаполнитьСтруктуруДействийПриДобавленииСтроки(ЭтаФорма, СтруктураДействий);
	
	УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ДополнитьОписаниеНастроекЗаполненияСлужебныхРеквизитовТабличнойЧасти(
		СтруктураДействий);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
	Если Не ТекущаяСтрока.ВедетсяУчетПоГТД Тогда
		ТекущаяСтрока.НомерГТД = Неопределено;
		ТекущаяСтрока.СтранаПроисхождения = Неопределено;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	РаботаСТабличнымиЧастямиКлиент.КэшироватьТекущуюСтроку(Элементы.Товары, ЭтотОбъект);
	НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий);
	
	НаборыКлиент.ПередУдалениемСтрокиТабличнойЧасти(ЭтаФорма, "Товары", Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	НеобходимоОбновитьСтатусыСерий = НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(
		Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Истина);

	ТоварыПослеУдаленияСервер(НеобходимоОбновитьСтатусыСерий, КэшированныеЗначения);

	Если НеобходимоОбновитьСтатусыСерий Тогда

		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий);

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	РаботаСТабличнымиЧастямиКлиент.КэшироватьТекущуюСтроку(Элементы.Товары, ЭтотОбъект);
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если НоменклатураКлиент.НеобходимоОбновитьСтатусыСерий(
		Элемент,КэшированныеЗначения,ПараметрыУказанияСерий) Тогда
		
		ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
		НоменклатураКлиент.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент, КэшированныеЗначения, ПараметрыУказанияСерий);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ХарактеристикаПриИзмененииПереопределяемый = Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
																ИмяФормы, "Товары");
	
	СтруктураДействий = Новый Структура("ХарактеристикаПриИзмененииПереопределяемый",
										ХарактеристикаПриИзмененииПереопределяемый);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	ВыбранноеЗначение.Значение = ТекущаяСтрока.Серия;
	ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущаяСтрока.ПолучитьИдентификатор();
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(ЭтаФорма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьПодборСерий(Элемент.ТекстРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоИзменении(Элемент)
	
	ТекущаяСтрока			= Элементы.Товары.ТекущиеДанные;
	ИмяПоляМестаХранения	= ИмяПоляМестаХранения(ТекущаяСтрока);
	
	СтруктураДействий = Новый Структура;
	
	УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ДополнитьОписаниеНастроекПересчетаРеквизитовТабличнойЧасти(
		Объект,
		СтруктураДействий,
		ИмяПоляМестаХранения,
		Истина);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыТипМестаХраненияПриИзменении(Элемент)
	
	МестаХранения = МестаХранения();
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если (ТекущиеДанные.ТипМестаХранения = МестаХранения.Склад
			И Не ЗначениеЗаполнено(ТекущиеДанные.Склад))
		Или (ТекущиеДанные.ТипМестаХранения = МестаХранения.Подразделение
			И Не ЗначениеЗаполнено(ТекущиеДанные.Подразделение))
		Или (ТекущиеДанные.ТипМестаХранения = МестаХранения.ДоговорКонтрагента
			И Не ЗначениеЗаполнено(ТекущиеДанные.Договор))
		Или Не ЗначениеЗаполнено(ТекущиеДанные.ТипМестаХранения) Тогда
		
		ЗначенияПоУмолчанию = Новый Структура("Склад, Подразделение, Договор, Хранитель, Контрагент, 
												|ПредставлениеМестаХранения");
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, ЗначенияПоУмолчанию);
		
	КонецЕсли;
	
	ЗаполнитьСтатусыУказанияСерийСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПредставлениеМестаХраненияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.Товары.ТекущиеДанные;
	
	ПроверитьСериюРассчитатьСтатус = Новый Структура("Склад, ПараметрыУказанияСерий",
													Неопределено, ПараметрыУказанияСерий);
	
	СтруктураДействий = Новый Структура("ПроверитьСериюРассчитатьСтатус", ПроверитьСериюРассчитатьСтатус);
	
	ИмяПоляМестаХранения = ИмяПоляМестаХранения(ТекущаяСтрока);
	
	УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ДополнитьОписаниеНастроекПересчетаРеквизитовТабличнойЧасти(
		Объект,
		СтруктураДействий,
		ИмяПоляМестаХранения,
		Истина);
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПредставлениеМестаХраненияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МестаХранения = МестаХранения();
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные.ТипМестаХранения = МестаХранения.Склад Тогда
		ИмяФормыОткрытия	= "Справочник.Склады.Форма.ФормаВыбора";
		ПараметрыФормы		= ПараметрыВыбораСклада();
	ИначеЕсли ТекущиеДанные.ТипМестаХранения = МестаХранения.Подразделение Тогда
		ИмяФормыОткрытия	= "Справочник.СтруктураПредприятия.Форма.ФормаВыбора";
		ПараметрыФормы		= ПараметрыВыбораПодразделения();
	ИначеЕсли ТекущиеДанные.ТипМестаХранения = МестаХранения.ДоговорКонтрагента Тогда
		ИмяФормыОткрытия	= "Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбора";
		ПараметрыФормы		= ПараметрыВыбораДоговора(ТекущиеДанные.Хранитель, ТекущиеДанные.Контрагент);
	КонецЕсли;
	
	ОткрытьФормуВыбораМестаХранения(ИмяФормыОткрытия, ПараметрыФормы, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПредставлениеМестаХраненияОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МестаХранения = МестаХранения();
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные.ТипМестаХранения = МестаХранения.Склад Тогда
		МестоХранения = ТекущиеДанные.Склад;
	ИначеЕсли ТекущиеДанные.ТипМестаХранения = МестаХранения.Подразделение Тогда
		МестоХранения = ТекущиеДанные.Подразделение;
	ИначеЕсли ТекущиеДанные.ТипМестаХранения = МестаХранения.ДоговорКонтрагента Тогда
		МестоХранения = ТекущиеДанные.Договор;
	КонецЕсли;
	
	ПоказатьЗначение(, МестоХранения);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПредставлениеМестаХраненияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	ЗаполнитьМестоХранения(ВыбранноеЗначение, ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПредставлениеМестаХраненияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МестаХранения = МестаХранения();
	ТекущиеДанные = Элементы.Товары.ТекущиеДанные;
	
	Если ТекущиеДанные.ТипМестаХранения = МестаХранения.Склад Тогда
		ТипДанныхВыбора			= Тип("СправочникСсылка.Склады");
		ПараметрыВыбораДанных	= ПараметрыВыбораСклада(Ложь);
	ИначеЕсли ТекущиеДанные.ТипМестаХранения = МестаХранения.Подразделение Тогда
		ТипДанныхВыбора			= Тип("СправочникСсылка.СтруктураПредприятия");
		ПараметрыВыбораДанных = ПараметрыВыбораПодразделения();
	ИначеЕсли ТекущиеДанные.ТипМестаХранения = МестаХранения.ДоговорКонтрагента Тогда
		ТипДанныхВыбора			= Тип("СправочникСсылка.ДоговорыКонтрагентов");
		ПараметрыВыбораДанных	= ПараметрыВыбораДоговора(ТекущиеДанные.Хранитель, ТекущиеДанные.Контрагент);
	Иначе
		Возврат;
	КонецЕсли;
	
	ПараметрыВыбораДанных.Вставить("СтрокаПоиска", Текст);
	ПараметрыВыбораДанных.Вставить("ВыборГруппИЭлементов",
									ПредопределенноеЗначение("ИспользованиеГруппИЭлементов.Элементы"));
	
	ДанныеВыбора = ПолучитьДанныеВыбора(ТипДанныхВыбора, ПараметрыВыбораДанных);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ИмяПоляМестаХранения(ТекущаяСтрока)
	
	МестаХранения			= МестаХранения();
	ИмяПоляМестаХранения	= ?(ТекущаяСтрока <> Неопределено,
								?(ТекущаяСтрока.ТипМестаХранения = МестаХранения.Склад,
									"Склад",
									?(ТекущаяСтрока.ТипМестаХранения = МестаХранения.Подразделение,
										"Подразделение",
										"Договор")),
									"Склад");
	
	Возврат ИмяПоляМестаХранения;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыВыбораСклада(ОткрытиеФормыВыбора = Истина)
	
	Отбор = Новый Структура("ЭтоГруппа", Ложь);
	ПараметрыВыбораДанных = Новый Структура("Отбор", Отбор);
	
	Если ОткрытиеФормыВыбора Тогда
		ПараметрыВыбораДанных.Вставить("ВыборГруппыСкладов", ИспользованиеГруппИЭлементов.Элементы);
	КонецЕсли;
	
	Возврат ПараметрыВыбораДанных;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыВыбораПодразделения()
	
	Отбор = Новый Структура("ПроизводственноеПодразделение", Истина);
	ПараметрыВыбораДанных = Новый Структура("Отбор", Отбор);
	
	Возврат ПараметрыВыбораДанных;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПараметрыВыбораДоговора(Партнер, Контрагент)
	
	ОперацииДоговора = Новый Массив;
	ОперацииДоговора.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСТоварыВПути"));
	ОперацииДоговора.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаВСтранахЕАЭСФактуровкаПоставки"));
	ОперацииДоговора.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаПоИмпортуТоварыВПути"));
	ОперацииДоговора.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаТоварыВПути"));
	ОперацииДоговора.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ЗакупкаУПоставщикаФактуровкаПоставки"));
	ОперацииДоговора.Добавить(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаХранениеСПравомПродажи"));
	
	Отбор = Новый Структура;
	Отбор.Вставить("ХозяйственнаяОперация",
					Новый ФиксированныйМассив(ОперацииДоговора));
	Отбор.Вставить("Статус",
					ПредопределенноеЗначение("Перечисление.СтатусыДоговоровКонтрагентов.Действует"));
	Отбор.Вставить("ПометкаУдаления", Ложь);
	
	ПараметрыВыбораДанных = Новый Структура;
	ПараметрыВыбораДанных.Вставить("Отбор", Отбор);
	ПараметрыВыбораДанных.Вставить("РазрешитьВыборПартнера");
	
	Если ЗначениеЗаполнено(Партнер) Тогда
		ПараметрыВыбораДанных.Вставить("Партнер", Партнер);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ПараметрыВыбораДанных.Вставить("Контрагент", Контрагент);
	КонецЕсли;
	
	Возврат ПараметрыВыбораДанных;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуВыбораМестаХранения(ИмяФормыОткрытия, ПараметрыФормы, ТекущиеДанные)
	
	ПараметрыОповещения = Новый Структура("ТекущиеДанные", ТекущиеДанные);
	ОписаниеОповещения  = Новый ОписаниеОповещения("ВыборМестаХраненияЗавершение",
													ЭтаФорма,
													ПараметрыОповещения);
	Если ИмяФормыОткрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ОткрытьФорму(ИмяФормыОткрытия,
					ПараметрыФормы,
					,
					,
					,
					,
					ОписаниеОповещения,
					РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборМестаХраненияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьМестоХранения(Результат, ДополнительныеПараметры.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УказатьСерии(Команда)
	
	ОткрытьПодборСерий();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыгрузитьУведомлениеВXML(Команда)
	
	ВыгрузитьУведомление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	
КонецПроцедуры

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	
КонецПроцедуры

#КонецОбласти

// СтандартныеПодсистемы.ПодключаемыеКоманды
//@skip-warning
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

//@skip-warning
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

//@skip-warning
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Элементы.ТоварыСтатусУказанияСерий.Видимость  = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	Элементы.ТоварыУказатьСерии.Видимость         = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	Элементы.ТоварыСерия.Видимость                = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьБлокаСостоянияОтправки()
	
	Элементы.БлокСостоянияОтправки.Видимость = Ложь;
	
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий)
	
	НоменклатураСервер.ОбработатьУказаниеСерий(Объект, ПараметрыУказанияСерий, ПараметрыФормыУказанияСерий);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения)
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Объект,
				ПараметрыУказанияСерий, ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор)
	
	Возврат НоменклатураСервер.ПараметрыФормыУказанияСерий(Объект, ПараметрыУказанияСерий, ТекущиеДанныеИдентификатор, ЭтаФорма);
	
КонецФункции

&НаСервере
Процедура ПодготовитьЗаполнитьУстановитьВидимостьСерий()
	
	ПараметрыУказанияСерий = Новый ФиксированнаяСтруктура(НоменклатураСервер.ПараметрыУказанияСерий(Объект, Документы.УведомлениеОВвозеПрослеживаемыхТоваров));
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	УстановитьВидимостьЭлементовСерий();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерий(Текст = "", ТекущиеДанные = Неопределено)
	Если НоменклатураКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма,ПараметрыУказанияСерий,Текст, ТекущиеДанные)Тогда
		Если ТекущиеДанные = Неопределено Тогда
			ТекущиеДанныеИдентификатор = Элементы.Товары.ТекущиеДанные.ПолучитьИдентификатор();
		Иначе
			ТекущиеДанныеИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		КонецЕсли;

		ПараметрыФормыУказанияСерий = ПараметрыФормыУказанияСерий(ТекущиеДанныеИдентификатор);
		
		ОткрытьФорму(ПараметрыФормыУказанияСерий.ИмяФормы,ПараметрыФормыУказанияСерий,ЭтаФорма,,,, Новый ОписаниеОповещения("ОткрытьПодборСерийЗавершение", ЭтотОбъект, Новый Структура("ПараметрыФормыУказанияСерий", ПараметрыФормыУказанияСерий)), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПодборСерийЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ПараметрыФормыУказанияСерий = ДополнительныеПараметры.ПараметрыФормыУказанияСерий;
    
    
    ЗначениеВозврата = Результат;
    
    Если ЗначениеВозврата <> Неопределено Тогда
        ОбработатьУказаниеСерийСервер(ПараметрыФормыУказанияСерий);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьТабличнуюЧастьПриИзмененииРеквизита(Элемент)
	
	Реквизит = Элемент.Заголовок;
	
	Если Объект.Товары.Количество() <> 0 Тогда
		
		ШаблонВопроса = НСтр("ru = 'При изменении %1 табличная часть будет очищена. Продолжить?'");
		
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонВопроса, Реквизит);
		
		Оповещение = Новый ОписаниеОповещения("ИзменениеРеквизитаЗаполненияЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
	Иначе
		
		СтароеЗначениеЕдиницаИзмерения = Объект.ЕдиницаИзмерения;
		СтароеЗначениеПервичныйДокумент = Объект.ПервичныйДокумент;
		СтароеЗначениеТНВЭД = Объект.КодТНВЭД;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменениеРеквизитаЗаполненияЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
	
		Объект.Товары.Очистить();
		
		СтароеЗначениеЕдиницаИзмерения = Объект.ЕдиницаИзмерения;
		СтароеЗначениеПервичныйДокумент = Объект.ПервичныйДокумент;
		СтароеЗначениеТНВЭД = Объект.КодТНВЭД;
		КодТНВЭДПриИзмененииНаСервере();

	Иначе
		
		Объект.ЕдиницаИзмерения = СтароеЗначениеЕдиницаИзмерения;
		Объект.ПервичныйДокумент = СтароеЗначениеПервичныйДокумент;
		Объект.КодТНВЭД = СтароеЗначениеТНВЭД;
		УстановитьПараметрыВыбораНоменклатуры();
		
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура КодТНВЭДПриИзмененииНаСервере()
	
	ЕдиницаПоТНВЭД = 
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.КодТНВЭД, "ЕдиницаИзмерения");
		
	Если НЕ ЗначениеЗаполнено(Объект.ЕдиницаИзмерения) Тогда
		Объект.ЕдиницаИзмерения = ЕдиницаПоТНВЭД;
	КонецЕсли;
	Объект.ЕдиницаПрослеживаемости = ЕдиницаПоТНВЭД;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьУведомление()
	
	ПрослеживаемостьКлиент.ВыгрузитьУведомлениеПоПрослеживаемости(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// ТоварыКоличествоПрослеживаемости
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыКоличествоПрослеживаемости");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.ЕдиницаИзмерения", ВидСравненияКомпоновкиДанных.Равно, Объект.ЕдиницаПрослеживаемости);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// ТоварыКодОКПД2
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыКодОКПД2");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Товары.ЕстьОКПД2", ВидСравненияКомпоновкиДанных.Равно, Ложь);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	// Страна происхождения
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "ТоварыСтранаПроисхождения");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.РНПТ", ВидСравненияКомпоновкиДанных.Равно, "");
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	
	НоменклатураСервер.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект);
	НоменклатураСервер.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтаФорма, "СерииВсегдаВТЧТовары");
	НоменклатураСервер.УстановитьУсловноеОформлениеСтатусовУказанияСерий(ЭтаФорма, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	УстановитьСостояниеДокумента();
	
	УправлениеФормой(ЭтотОбъект);

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВременныеРеквизиты()
	
	ТаблицаОКПД2 = Объект.Товары.Выгрузить(, "КодОКПД2");
	ТаблицаОКПД2.Свернуть("КодОКПД2");
	ЕстьОКПД2 = Ложь;
	
	Если ТаблицаОКПД2.Количество() > 1 Тогда
		ЕстьОКПД2 = Истина;
	Иначе
		
		Если ТаблицаОКПД2.Количество() > 0 Тогда
			ЕстьОКПД2 = ЗначениеЗаполнено(ТаблицаОКПД2[0].КодОКПД2);
		КонецЕсли;
		
	КонецЕсли;
		
	Для каждого ТекущаяСтрока Из Объект.Товары Цикл
		
		ТекущаяСтрока.ЕдиницаИзмерения = Объект.ЕдиницаИзмерения;
		ТекущаяСтрока.ЕдиницаПрослеживаемости = Объект.ЕдиницаПрослеживаемости;
		ТекущаяСтрока.ЕстьОКПД2 = ЕстьОКПД2;
		
	КонецЦикла;
	
	СтароеЗначениеЕдиницаИзмерения = Объект.ЕдиницаИзмерения;
	СтароеЗначениеПервичныйДокумент = Объект.ПервичныйДокумент;
	СтароеЗначениеТНВЭД = Объект.КодТНВЭД;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	Объект   = Форма.Объект;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСтруктуруДействийПриДобавленииСтроки(Форма, СтруктураДействий)
	
	ТекущаяСтрока	= Форма.Элементы.Товары.ТекущиеДанные;
	ПолеФормы		= Форма.Элементы.ТоварыТипМестаХранения;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		
		Если Не ПолеФормы.Видимость
			И Не ЗначениеЗаполнено(ТекущаяСтрока.ТипМестаХранения) Тогда
			
			ЗаполнитьТипМестаХраненияПоУмолчанию = Новый Структура("ТипМестаХранения",
																	"Перечисление.ТипыМестХранения.Склад");
			
			СтруктураДействий.Вставить("ЗаполнитьТипМестаХраненияПоУмолчанию", ЗаполнитьТипМестаХраненияПоУмолчанию);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийСервер()
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект, ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМестоХранения(МестоХранения, ТекущиеДанные)
	
	МестаХранения				= МестаХранения();
	ПредставлениеМестаХранения	= Строка(МестоХранения);
	
	ЗначенияПоУмолчанию = Новый Структура("Склад, Подразделение, Договор, Хранитель, Контрагент");
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ЗначенияПоУмолчанию);
	
	Если ТекущиеДанные.ТипМестаХранения = МестаХранения.Склад Тогда;
		ТекущиеДанные.Склад = МестоХранения;
	ИначеЕсли ТекущиеДанные.ТипМестаХранения = МестаХранения.Подразделение Тогда
		ТекущиеДанные.Подразделение = МестоХранения;
	ИначеЕсли ТекущиеДанные.ТипМестаХранения = МестаХранения.ДоговорКонтрагента Тогда
		ТекущиеДанные.Договор = МестоХранения;
		
		РеквизитыДоговора = РеквизитыДоговора(МестоХранения);
		ТекущиеДанные.Хранитель  = РеквизитыДоговора.Партнер;
		ТекущиеДанные.Контрагент = РеквизитыДоговора.Контрагент;
	КонецЕсли;
	
	ТекущиеДанные.ПредставлениеМестаХранения = ПредставлениеМестаХранения(ПредставлениеМестаХранения,
																			Строка(ТекущиеДанные.Хранитель));
	
	ЗаполнитьСтатусыУказанияСерийСервер();
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция МестаХранения()
	
	МестаХранения = Новый Структура;
	
	МестаХранения.Вставить("Склад",         ПредопределенноеЗначение("Перечисление.ТипыМестХранения.Склад"));
	МестаХранения.Вставить("Подразделение", ПредопределенноеЗначение("Перечисление.ТипыМестХранения.Подразделение"));
	МестаХранения.Вставить("ДоговорКонтрагента",
							ПредопределенноеЗначение("Перечисление.ТипыМестХранения.ДоговорКонтрагента"));
	
	Возврат МестаХранения;
	
КонецФункции

&НаСервере
Функция РеквизитыДоговора(Договор)
	
	РеквизитыДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Договор, "Партнер, Контрагент");
	
	Возврат РеквизитыДоговора;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ПрослеживаемостьСобытияФормКлиентПереопределяемый.ОбработкаОповещения(ЭтотОбъект, Объект.Ссылка, ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованию(Команда)
	
	
	Если Объект.Товары.Количество() <> 0 Тогда
		
		ТекстВопроса = НСтр("ru = 'Табличная часть будет очищена. Продолжить?'");
		
		Оповещение = Новый ОписаниеОповещения("ЗаполнениеТЧПоОснованиюЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		
	Иначе
		
		ЗаполнениеТЧТоварыНаСервере();
		
	КонецЕсли;


КонецПроцедуры

&НаСервере
Процедура ТоварыПослеУдаленияСервер(НеобходимоОбновитьСтатусыСерий, КэшированныеЗначения)

	Если НеобходимоОбновитьСтатусыСерий Тогда

		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Неопределено, КэшированныеЗначения);

	КонецЕсли;

	СобытияФорм.ПриИзмененииЭлемента(ЭтотОбъект, "Товары");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнениеТЧПоОснованиюЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт

	Если РезультатВыбора = КодВозвратаДиалога.Да Тогда
		ЗаполнениеТЧТоварыНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнениеТЧТоварыНаСервере()

	Объект.Товары.Загрузить(Документы.УведомлениеОВвозеПрослеживаемыхТоваров.ДанныеТЧТоварыПоОснованию(
		Объект.ПервичныйДокумент,
		Объект.КодТНВЭД,
		Объект.ЕдиницаИзмерения,
		Объект.Ссылка));
	
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(Объект,ПараметрыУказанияСерий);
	ЗаполнитьСлужебныеРеквизитыПоНоменклатуре();
	ЗаполнитьПредставлениеМестаХранения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(Объект.Ссылка);

КонецПроцедуры

#КонецОбласти
