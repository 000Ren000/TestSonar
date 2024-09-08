﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПриЧтенииСозданииНаСервере();
	КонецЕсли;
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Подразделение", Объект.Ссылка));
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("Объект", Объект);
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект, Элементы.ГруппаРазблокироватьРеквизиты);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.РаботаСФайлами
	ПараметрыГиперссылки = РаботаСФайлами.ГиперссылкаФайлов();
	ПараметрыГиперссылки.Размещение = "КоманднаяПанель";
	РаботаСФайлами.ПриСозданииНаСервере(ЭтотОбъект, ПараметрыГиперссылки);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.РаботаСФайлами
	РаботаСФайламиКлиент.ПриОткрытии(ЭтотОбъект, Отказ);
	// Конец СтандартныеПодсистемы.РаботаСФайлами
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ПриЧтенииСозданииНаСервере();
	
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	//++ Устарело_Производство21


	//-- Устарело_Производство21
	
	УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Подразделение", Объект.Ссылка));
	
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "Ссылка");
	
	// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	ЗапретРедактированияРеквизитовОбъектов.ЗаблокироватьРеквизиты(ЭтотОбъект, Элементы.ГруппаРазблокироватьРеквизиты);
	// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("ПеречислениеСсылка.ВариантыОбособленногоУчетаТоваров") Тогда
		
		Модифицированность = Истина;
		Объект.ВариантОбособленногоУчетаТоваров = ВыбранноеЗначение;
		ЗаполнитьПредставлениеПараметров();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	Оповестить("Запись_СтруктураПредприятия",, Объект.Ссылка);
	

	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользованиеВСхемахОбеспечения(Команда)
	
	
	Возврат; // в УТ пустой обработчик
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_СвойстваВыполнитьКоманду(ЭлементИлиКоманда, НавигационнаяСсылка = Неопределено, СтандартнаяОбработка = Неопределено)
	УправлениеСвойствамиКлиент.ВыполнитьКоманду(ЭтотОбъект, ЭлементИлиКоманда, СтандартнаяОбработка);
КонецПроцедуры

&НаКлиенте
Процедура КомандаПараметрыПроизводственногоПодразделения(Команда)
	
	ОткрытьФорму(
		"Справочник.СтруктураПредприятия.Форма.ПараметрыПроизводственногоПодразделения",
		Новый Структура("Ссылка, АдресХранилищаДанныеОбъекта", Объект.Ссылка, ДанныеОбъектаВХранилище()),
		ЭтотОбъект,,,,
		Новый ОписаниеОповещения("ПараметрыПроизводственногоПодразделенияЗавершение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыОбособленногоУчетаТоваров(Команда)
	
	ПараметрыФормы = Новый Структура("ВариантОбособленногоУчетаТоваров", Объект.ВариантОбособленногоУчетаТоваров);
	ОткрытьФорму("Справочник.СтруктураПредприятия.Форма.ПараметрыОбособленногоУчетаТоваров", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъекта(Команда)
	
	ПараметрыПроцедуры = ОбщегоНазначенияУТКлиент.ПараметрыРазрешенияРедактированияРеквизитовОбъекта();
	ПараметрыПроцедуры.ОповещениеОРазблокировке = Новый ОписаниеОповещения("Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение", ЭтотОбъект);
	ПараметрыПроцедуры.Объект = Новый Структура("Ссылка", Неопределено);
	
	ОбщегоНазначенияУТКлиент.РазрешитьРедактированиеРеквизитовОбъекта(ЭтаФорма, ПараметрыПроцедуры);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_КомандаПанелиПрисоединенныхФайлов(Команда)
	 РаботаСФайламиКлиент.КомандаУправленияПрисоединеннымиФайлами(ЭтотОбъект, Команда);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПроверкаПеретаскивания(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраПеретаскивание(ЭтотОбъект, Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.РаботаСФайлами
&НаКлиенте
Процедура Подключаемый_ПолеПредпросмотраНажатие(Элемент, СтандартнаяОбработка)
	 РаботаСФайламиКлиент.ПолеПредпросмотраНажатие(ЭтотОбъект, Элемент, СтандартнаяОбработка);
КонецПроцедуры
// Конец СтандартныеПодсистемы.РаботаСФайлами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЧтенииСозданииНаСервере()
	
	
	ПерейтиКПараметрамЗаголовок = ?(ПравоДоступа("Изменение", Метаданные.Справочники.СтруктураПредприятия),
		НСтр("ru = 'Изменить'"),
		НСтр("ru = 'Подробно'"));
		
	Если ПолучитьФункциональнуюОпцию("ИспользоватьПроизводство") Тогда
		Элементы.ПараметрыПроизводственногоПодразделения.Видимость = Истина;
		Элементы.ПараметрыПроизводственногоПодразделения.Заголовок = ПерейтиКПараметрамЗаголовок;
	Иначе
		Элементы.ПараметрыПроизводственногоПодразделения.Видимость = Ложь;
	КонецЕсли;
	
	Если ПолучитьФункциональнуюОпцию("ФормироватьВидыЗапасовПоПодразделениямМенеджерам") Тогда
		Элементы.ПараметрыОбособленногоУчетаТоваров.Видимость = Истина;
		Элементы.ПараметрыОбособленногоУчетаТоваров.Заголовок = ПерейтиКПараметрамЗаголовок;
	Иначе
		Элементы.ПараметрыОбособленногоУчетаТоваров.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьПредставлениеПараметров();
	НастроитьЗависимыеЭлементыФормы(ЭтаФорма);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПроизводственногоПодразделенияЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		
		ЗагрузитьДанныеОбъектаИзХранилища(РезультатЗакрытия);
		
		НастроитьЗависимыеЭлементыФормы(ЭтаФорма, "ПроизводственноеПодразделение");
		
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеОбъектаИзХранилища(АдресХранилищаДанныеОбъекта)
	
	Если НЕ ЭтоАдресВременногоХранилища(АдресХранилищаДанныеОбъекта) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта = ПолучитьИзВременногоХранилища(АдресХранилищаДанныеОбъекта);
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		Объект[Реквизит.Имя] = ДанныеОбъекта[Реквизит.Имя];
	КонецЦикла;
	
	Для каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		Объект[ТабличнаяЧасть.Имя].Загрузить(ДанныеОбъекта[ТабличнаяЧасть.Имя]);
	КонецЦикла;
	
	СкладМатериалов = ДанныеОбъекта.СкладМатериалов;
	
	ЗаполнитьПредставлениеПараметров();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПредставлениеПараметров()
	
	ЭтоКА = ПолучитьФункциональнуюОпцию("КомплекснаяАвтоматизация");
	
	
	ПредставлениеПроизводственногоПодразделения = "";
	Если Объект.ПодразделениеДиспетчер
		И Объект.ПроизводствоПоЗаказам
		И Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение диспетчирует заказы на производство, производит продукцию по заказам и без заказов на производство.'");
			
	ИначеЕсли Объект.ПодразделениеДиспетчер
		И Объект.ПроизводствоПоЗаказам
		И Не Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение диспетчирует заказы на производство и производит продукцию по заказам.'");
			
	ИначеЕсли Объект.ПодразделениеДиспетчер
		И Не Объект.ПроизводствоПоЗаказам
		И Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение диспетчирует заказы на производство и производит продукцию без заказов.'");
		
	ИначеЕсли Объект.ПодразделениеДиспетчер
		И Не Объект.ПроизводствоПоЗаказам
		И Не Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение диспетчирует заказы на производство.'");
			
	ИначеЕсли Не Объект.ПодразделениеДиспетчер
		И Объект.ПроизводствоПоЗаказам
		И Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение производит продукцию по заказам и без заказов на производство.'");
			
	ИначеЕсли Не Объект.ПодразделениеДиспетчер
		И Объект.ПроизводствоПоЗаказам
		И Не Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение производит продукцию по заказам на производство.'");
			
	ИначеЕсли Не Объект.ПодразделениеДиспетчер
		И Не Объект.ПроизводствоПоЗаказам
		И Объект.ПроизводствоБезЗаказов
		И Не ЭтоКА Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение производит продукцию без заказов на производство.'");
			
	ИначеЕсли ЭтоКА И Объект.ПроизводственноеПодразделение Тогда
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение производит продукцию.'");
		
	Иначе
		
		ПредставлениеПроизводственногоПодразделения =
			НСтр("ru = 'Подразделение не является производственным.'");
		
	КонецЕсли;
	
	Команды["ПараметрыПроизводственногоПодразделения"].Подсказка = ПредставлениеПроизводственногоПодразделения;
	
	ПредставлениеОбособленногоУчетаТоваров = "";
	Если Объект.ВариантОбособленногоУчетаТоваров = Перечисления.ВариантыОбособленногоУчетаТоваров.НеВедется Тогда
		ПредставлениеОбособленногоУчетаТоваров = НСтр("ru = 'Обособленный учет товаров не ведется.'");
	ИначеЕсли Объект.ВариантОбособленногоУчетаТоваров = Перечисления.ВариантыОбособленногоУчетаТоваров.ПоПодразделению Тогда
		ПредставлениеОбособленногоУчетаТоваров = НСтр("ru = 'Обособленный учет товаров ведется по подразделению.'");
	ИначеЕсли Объект.ВариантОбособленногоУчетаТоваров = Перечисления.ВариантыОбособленногоУчетаТоваров.ПоМенеджерамПодразделения Тогда
		ПредставлениеОбособленногоУчетаТоваров = НСтр("ru = 'Обособленный учет товаров ведется по менеджерам подразделения.'");
	КонецЕсли;
	Команды["ПараметрыОбособленногоУчетаТоваров"].Подсказка = ПредставлениеОбособленногоУчетаТоваров;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЗависимыеЭлементыФормы(Форма, СписокРеквизитов = "")
	
	Инициализация = ПустаяСтрока(СписокРеквизитов);
	СтруктураРеквизитов = Новый Структура(СписокРеквизитов);
	
	Элементы = Форма.Элементы;
	Объект = Форма.Объект;
	
	Если СтруктураРеквизитов.Свойство("ПроизводственноеПодразделение")
		ИЛИ СтруктураРеквизитов.Свойство("Ссылка")
		ИЛИ Инициализация Тогда
		Элементы.ИспользованиеВСхемахОбеспечения.Видимость = 
				Объект.ПроизводственноеПодразделение 
				И Форма.ЕстьПравоПросмотраСхемОбеспечения
				И ЗначениеЗаполнено(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДанныеОбъектаВХранилище()
	
	ДанныеОбъекта = Новый Структура;
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	Для каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		ДанныеОбъекта.Вставить(Реквизит.Имя, Объект[Реквизит.Имя]);
	КонецЦикла;
	
	Для каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		ДанныеОбъекта.Вставить(ТабличнаяЧасть.Имя, Объект[ТабличнаяЧасть.Имя].Выгрузить());
	КонецЦикла;
	
	ДанныеОбъекта.Вставить("СкладМатериалов", СкладМатериалов);
	
	Возврат ПоместитьВоВременноеХранилище(ДанныеОбъекта, УникальныйИдентификатор);
	
КонецФункции


// СтандартныеПодсистемы.Свойства
&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов
&НаКлиенте
Процедура Подключаемый_РазрешитьРедактированиеРеквизитовОбъектаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Массив") И Результат.Количество() > 0 Тогда
		
		ЗапретРедактированияРеквизитовОбъектовКлиент.УстановитьДоступностьЭлементовФормы(ЭтаФорма, Результат);
		
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

#КонецОбласти
