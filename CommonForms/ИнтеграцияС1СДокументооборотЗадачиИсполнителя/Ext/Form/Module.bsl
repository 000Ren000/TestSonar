﻿#Область ОписаниеПеременных

&НаКлиенте
Перем НомерАктивизированнойСтроки;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервереФормРазмещаемыхНаРабочемСтоле(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Автообновление = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеграцияС1СДокументооборот", "Автообновление", Истина);
	ПериодАвтообновления = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ИнтеграцияС1СДокументооборот", "ПериодАвтообновления", 900);
	
	Элементы.ГруппаСтраницы.Доступность = Ложь;
	Элементы.ГруппаПодвал.Доступность = Ложь;
	Элементы.Автообновление.Доступность = Ложь;
	
	УстановитьОформлениеЗадач(УсловноеОформление);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИнтеграцияС1СДокументооборотом_УспешноеПодключение" И Источник <> ЭтотОбъект Тогда
		ПриПодключении();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_ДокументооборотЗадача" И Источник = ЭтотОбъект Тогда
		ОбновитьСписокЗадачЧастично();
		РазвернутьГруппыЗадач();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьПодключение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатие(Элемент)
	
	Оповещение = Новый ОписаниеОповещения("ДекорацияНастройкиАвторизацииНажатиеЗавершение", ЭтотОбъект);
	ИмяФормыПараметров = "Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.АвторизацияВ1СДокументооборот";
	
	ОткрытьФорму(ИмяФормыПараметров,, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНастройкиАвторизацииНажатиеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ПриПодключении();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполненныеПриИзменении(Элемент)
	
	Модифицированность = Ложь;
	ОбновитьСписокЗадачНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ГруппаЗадачиОтМеня Тогда
		Если Не ЗадачиОтМеняСчитаны Тогда
			ОбновитьСписокЗадачНаСервере();
			РазвернутьГруппыЗадач();
			ЗадачиОтМеняСчитаны = Истина;
		КонецЕсли;
	ИначеЕсли ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		Если Не ЗадачиМнеСчитаны Тогда
			ОбновитьСписокЗадачНаСервере();
			РазвернутьГруппыЗадач();
			ЗадачиМнеСчитаны = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачиМне

&НаКлиенте
Процедура ЗадачиМнеПриАктивизацииСтроки(Элемент)
	
	Если НомерАктивизированнойСтроки <> Элемент.ТекущаяСтрока Тогда
		
		НомерАктивизированнойСтроки = Элемент.ТекущаяСтрока;
		СтрокаЗадачи = Элементы.ЗадачиМне.ТекущиеДанные;
		Если СтрокаЗадачи = Неопределено Или СтрокаЗадачи.Группировка Тогда
			Элементы.ПринятьКИсполнению.Доступность = Ложь;
			Элементы.ЗадачиМнеКонтекстноеМенюПринятьКИсполнению.Доступность = Ложь;
			Элементы.ОтменитьПринятиеКИсполнению.Доступность = Ложь;
			Элементы.ЗадачиМнеКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = Ложь;
		Иначе
			Элементы.ПринятьКИсполнению.Доступность = Не СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ЗадачиМнеКонтекстноеМенюПринятьКИсполнению.Доступность = Не СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ОтменитьПринятиеКИсполнению.Доступность = СтрокаЗадачи.ПринятаКИсполнению;
			Элементы.ЗадачиМнеКонтекстноеМенюОтменитьПринятиеКИсполнению.Доступность = СтрокаЗадачи.ПринятаКИсполнению;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиМнеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Задача = Элементы.ЗадачиМне.ТекущиеДанные;
	Если Задача <> Неопределено Тогда
		Если Не Задача.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ID", Задача.ЗадачаID);
			ПараметрыФормы.Вставить("type", Задача.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача", 
				ПараметрыФормы, ЭтотОбъект, Задача.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиМнеПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиМнеПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗадачиОтМеня
&НаКлиенте
Процедура ЗадачиОтМеняВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Задача = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	Если Задача <> Неопределено Тогда
		Если Не Задача.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ID", Задача.ЗадачаID);
			ПараметрыФормы.Вставить("type", Задача.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача", ПараметрыФормы, ЭтотОбъект, Задача.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПередУдалением(Элемент, Отказ)

	Отказ = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗадачиОтМеняПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	Задача = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	Если Задача <> Неопределено Тогда
		Если Не Задача.Группировка Тогда
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("ID", Задача.ЗадачаID);
			ПараметрыФормы.Вставить("type", Задача.ЗадачаТип);
			ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача", ПараметрыФормы, ЭтотОбъект, Задача.ЗадачаID);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	Модифицированность = Ложь;
	ОбновитьСписокЗадачНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЗадачу(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТекущиеДанные = Элементы.ЗадачиМне.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ТекущиеДанные.Группировка Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(
			ТекущиеДанные.ЗадачаТип,
			ТекущиеДанные.ЗадачаID,
			ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредмет(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТекущиеДанные = Элементы.ЗадачиМне.ТекущиеДанные; 
	Иначе
		ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(
		ТекущиеДанные.ПредметТип,
		ТекущиеДанные.ПредметID,
		ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПроцесс(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТекущиеДанные = Элементы.ЗадачиМне.ТекущиеДанные; 
	Иначе
		ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	КонецЕсли;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект(
		ТекущиеДанные.ПроцессТип,
		ТекущиеДанные.ПроцессID,
		ЭтотОбъект);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьПроцесс(Команда)
	
	Модифицированность = Ложь;
	Оповещение = Новый ОписаниеОповещения("СоздатьПроцессЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотКлиент.СоздатьБизнесПроцесс(,, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПисьмо(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТекущиеДанные = Элементы.ЗадачиМне.ТекущиеДанные; 
	Иначе
		ТекущиеДанные = Элементы.ЗадачиОтМеня.ТекущиеДанные;
	КонецЕсли;
	
	Если Не ДоступенФункционалЗадачиОтМеня Тогда // так!
		ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ОткрытьОбъект("DMOutgoingEMail","", ЭтотОбъект);
	Иначе
		ПараметрыФормы = Новый Структура("Предмет", Новый Структура);
		
		ПараметрыФормы.Предмет.Вставить("name", ТекущиеДанные.Задача);
		ПараметрыФормы.Предмет.Вставить("ID", ТекущиеДанные.ЗадачаID);
		ПараметрыФормы.Предмет.Вставить("type", ТекущиеДанные.ЗадачаТип);
		
		ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.ИсходящееПисьмо",ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	ПринятьЗадачиКИсполнению();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	ОтменитьПринятиеЗадачКИсполнению();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоВажности(Команда)
	СгруппироватьПоКолонке("ВажностьСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоБезГруппировки(Команда)
	СгруппироватьПоКолонке("");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоТочкеМаршрута(Команда)
	СгруппироватьПоКолонке("ТочкаМаршрута");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоАвтору(Команда)
	СгруппироватьПоКолонке("Автор");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоПредмету(Команда)
	СгруппироватьПоКолонке("Предмет");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоИсполнителю(Команда)
	СгруппироватьПоКолонке("Исполнитель");
КонецПроцедуры

&НаКлиенте
Процедура ЗадатьВопросАвтору(Команда)
	
	Модифицированность = Ложь;
	
	Если Элементы.ЗадачиМне.ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли Элементы.ЗадачиМне.ТекущиеДанные.Группировка Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ID", Элементы.ЗадачиМне.ТекущиеДанные.ЗадачаID);
	ПараметрыФормы.Вставить("type", Элементы.ЗадачиМне.ТекущиеДанные.ЗадачаТип);
	ПараметрыФормы.Вставить("ВидВопроса", НСтр("ru = 'Иное'"));
	ПараметрыФормы.Вставить("ВидВопросаID", "Иное"); //@NON-NLS-2
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборот.Форма.БизнесПроцессРешениеВопросовНовыйВопрос",
		ПараметрыФормы, ЭтотОбъект, Элементы.ЗадачиМне.ТекущиеДанные.ЗадачаID);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьПроцессЗавершение(Результат, ПараметрыОповещения) Экспорт
	
	ОбновитьСписокЗадачЧастично();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьГруппыЗадач()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		Дерево = ЗадачиМне;
		ЭлементДерево = Элементы.ЗадачиМне;
	Иначе
		Дерево = ЗадачиОтМеня;
		ЭлементДерево = Элементы.ЗадачиОтМеня;
	КонецЕсли;
	
	ЭлементыДерева = Дерево.ПолучитьЭлементы();
	
	Для Каждого ЭлементДерева Из ЭлементыДерева Цикл
		Если ЭлементДерева.Группировка Тогда
			ЭлементДерево.Развернуть(ЭлементДерева.ПолучитьИдентификатор(), Ложь);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоКолонке(ИмяКолонки)
	
	Модифицированность = Ложь;
	СгруппироватьПоКолонкеНаСервере(ИмяКолонки);
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаСервере
Процедура СгруппироватьПоКолонкеНаСервере(ИмяКолонки)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачСсылка = ТаблицаЗадачМнеСсылка;
		ИмяСпискаЗадач = "ЗадачиМне";
		СписокЗадач = ЗадачиМне;
		РежимГруппировкиЗадачиМне = ИмяКолонки;
		РежимГруппировки = РежимГруппировкиЗадачиМне;
	Иначе
		ТаблицаЗадачСсылка = ТаблицаЗадачОтМеняСсылка;
		ИмяСпискаЗадач = "ЗадачиОтМеня";
		СписокЗадач = ЗадачиОтМеня;
		РежимГруппировкиЗадачиОтМеня = ИмяКолонки;
		РежимГруппировки = РежимГруппировкиЗадачиОтМеня;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТаблицаЗадачСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяЗадача = Элементы.Найти(ИмяСпискаЗадач).ТекущаяСтрока;
	Если ТекущаяЗадача <> Неопределено Тогда
		СтрокаТекущейЗадачи = СписокЗадач.НайтиПоИдентификатору(ТекущаяЗадача);
		Если СтрокаТекущейЗадачи = Неопределено Тогда
			ТекущаяЗадача = Неопределено;
		Иначе
			ТекущаяЗадача = СтрокаТекущейЗадачи.ЗадачаID;
		КонецЕсли;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение(ИмяСпискаЗадач); // ДеревоЗначений
	
	ТаблицаЗадач = ПолучитьИзВременногоХранилища(ТаблицаЗадачСсылка); // ТаблицаЗначений
	
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(РежимГруппировки) Тогда
		ТаблицаГруппировок = ТаблицаЗадач.Скопировать();
		ТаблицаГруппировок.Свернуть(РежимГруппировки);
		Для Каждого СтрокаГруппировки Из ТаблицаГруппировок Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.Задача = СтрокаГруппировки[РежимГруппировки];
			СтрокаДерева.КартинкаЗадачи = 2;
			СтрокаДерева.Важность = 1;
			СтрокаДерева.Группировка = Истина;
			СтрокиГруппировки = ТаблицаЗадач.НайтиСтроки(Новый Структура(РежимГруппировки,СтрокаГруппировки[РежимГруппировки]));
			Для Каждого Строка Из СтрокиГруппировки Цикл
				СтрокаЭлемента = СтрокаДерева.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЭлемента,Строка);
			КонецЦикла;
			СтрокаДерева.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
		КонецЦикла;
		Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Дерево;
		Дерево.Строки.Сортировать("Задача");
	Иначе
		Для Каждого Строка Из ТаблицаЗадач Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДерева,Строка);
		КонецЦикла;
		Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Список;
		Дерево.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, ИмяСпискаЗадач);
	УстановитьТекущуюСтроку(ТекущаяЗадача);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекущуюСтроку(ЗадачаID)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ИмяСпискаЗадач = "ЗадачиМне";
		СписокЗадач = ЗадачиМне;
	Иначе
		ИмяСпискаЗадач = "ЗадачиОтМеня";
		СписокЗадач = ЗадачиОтМеня;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗадачаID) Тогда
		Если Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Список Тогда
			СтрокиЗадачи = СписокЗадач.ПолучитьЭлементы();
			Для Каждого СтрокаЗадачи Из СтрокиЗадачи Цикл
				Если СтрокаЗадачи.ЗадачаID = ЗадачаID Тогда
					Элементы[ИмяСпискаЗадач].ТекущаяСтрока = СтрокаЗадачи.ПолучитьИдентификатор();
					Прервать;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого ГруппаДерева Из СписокЗадач.ПолучитьЭлементы() Цикл
				СтрокиЗадачи = ГруппаДерева.ПолучитьЭлементы();
				Для Каждого СтрокаЗадачи Из СтрокиЗадачи Цикл
					Если СтрокаЗадачи.ЗадачаID = ЗадачаID Тогда
						Элементы[ИмяСпискаЗадач].ТекущаяСтрока = СтрокаЗадачи.ПолучитьИдентификатор();
						Прервать;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Проверяет подключение к ДО, выводя окно авторизации, если необходимо, и изменяя форму согласно результату.
//
&НаКлиенте
Процедура ПроверитьПодключение()
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроверитьПодключениеЗавершение", ЭтотОбъект);
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ПроверитьПодключение(
		ОписаниеОповещения,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПодключениеЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Истина Тогда
		ПриПодключении();
	Иначе // не удалось подключиться к ДО
		ОбработатьФормуСогласноВерсииСервиса();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриПодключении()
	
	Если ОбработатьФормуСогласноВерсииСервиса() Тогда
		РазвернутьГруппыЗадач();
#Если Не ВебКлиент Тогда
		Если ДоступенФункционалЗадачи Тогда
			Элементы.Автообновление.Доступность = Истина;
			Если Автообновление Тогда
				ПодключитьОбработчикОжидания("Автообновление", ПериодАвтообновления);
			КонецЕсли;
		КонецЕсли;
#КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбработатьФормуСогласноВерсииСервиса()
	
	Заголовок = НСтр("ru = 'Документооборот: Мои задачи'");
	
	ВерсияСервиса = ИнтеграцияС1СДокументооборотБазоваяФункциональность.ВерсияСервиса();
	
	Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиентСервер.СервисДоступен(ВерсияСервиса) Тогда
		Элементы.ГруппаФункционалНеПоддерживается.Видимость = Истина;
		Элементы.ГруппаПроверкаАвторизации.Видимость = Истина;
		Элементы.ДекорацияФункционалНеПоддерживается.Заголовок = НСтр("ru = 'Нет доступа к 1С:Документообороту.'");
		Возврат Ложь;
	КонецЕсли;
	
	ФормаОбработанаУспешно = Истина;
	
	Попытка
		
		Заголовок = НСтр("ru = 'Документооборот: Мои задачи'");
		
		Элементы.ГруппаПроверкаАвторизации.Видимость = Ложь;
		Элементы.ГруппаФункционалНеПоддерживается.Видимость = Ложь;
		
		// задачи
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("1.2.6.2")
				И Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("3.0.1.1") Тогда
			Элементы.ГруппаСтраницы.Доступность = Истина;
			Элементы.ГруппаПодвал.Доступность = Истина;
			ДоступенФункционалЗадачи = Истина;
			ДоступенФункционалЗадачиОтМеня
				= ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("1.3.2.3");
			ОбновитьСписокЗадачНаСервере();
		Иначе
			Элементы.ГруппаСтраницы.Доступность = Ложь;
			Элементы.ГруппаПодвал.Доступность = Ложь;
			ДоступенФункционалЗадачи = Ложь;
			ДоступенФункционалЗадачиОтМеня = Ложь;
			Обработки.ИнтеграцияС1СДокументооборот.ОбработатьФормуПриНедоступностиФункционалаВерсииСервиса(ЭтотОбъект);
			Элементы.Выполненные.ТолькоПросмотр = Истина;
		КонецЕсли;
		// решение вопросов
		Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("1.2.7.3") Тогда
			Элементы.ЗадатьВопросАвтору.Видимость = Ложь;
		КонецЕсли;
		// почта
		Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("1.2.8.1.CORP") Тогда
			Элементы.СоздатьПисьмо.Видимость = Ложь;
			Элементы.СоздатьПисьмо2.Видимость = Ложь;
		КонецЕсли;
		// принятие задач к исполнению.
		Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("1.2.7.3.CORP") Тогда
			Элементы.ПринятьКИсполнению.Видимость = Ложь;
			Элементы.ЗадачиМнеКонтекстноеМенюПринятьКИсполнению.Видимость = Ложь;
		КонецЕсли;
		// отмена принятия задач к исполнению.
		Если Не ИнтеграцияС1СДокументооборотБазоваяФункциональность.ДоступенФункционалВерсииСервиса("2.1.18.1.CORP") Тогда
			Элементы.ОтменитьПринятиеКИсполнению.Видимость = Ложь;
			Элементы.ЗадачиМнеКонтекстноеМенюОтменитьПринятиеКИсполнению.Видимость = Ложь;
		КонецЕсли;
		
		Если Не ДоступенФункционалЗадачиОтМеня Тогда
			Элементы.ЗадачиОтМеня.Видимость = Ложь;
			Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
		Иначе
			Элементы.ЗадачиОтМеня.Видимость = Истина;
			Элементы.ГруппаСтраницы.ОтображениеСтраниц = ОтображениеСтраницФормы.ЗакладкиСверху;
		КонецЕсли;
		
	Исключение
		
		Если ИнтеграцияС1СДокументооборотБазоваяФункциональностьВызовСервера.НужноОбработатьФорму(ИнформацияОбОшибке()) Тогда
			ОбработатьФормуСогласноВерсииСервиса();
		КонецЕсли;
		
	КонецПопытки;
	
	Возврат ФормаОбработанаУспешно;
	
КонецФункции

&НаКлиенте
Процедура Автообновление()
	
	ОбновитьСписокЗадачНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАвтообновления()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Автообновление", Автообновление);
	ПараметрыФормы.Вставить("ПериодАвтообновления", ПериодАвтообновления);
	
	Оповещение = Новый ОписаниеОповещения("НастройкаАвтообновленияЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.ИнтеграцияС1СДокументооборотБазоваяФункциональность.Форма.НастройкаАвтообновления",
		ПараметрыФормы, ЭтотОбъект,,,, Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаАвтообновленияЗавершение(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Автообновление = Результат.Автообновление;
	ПериодАвтообновления = Результат.ПериодАвтообновления;
	
	ОтключитьОбработчикОжидания("Автообновление");
	
	МассивСтруктур = Новый Массив;
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ИнтеграцияС1СДокументооборот");
	Элемент.Вставить("Настройка", "Автообновление");
	Элемент.Вставить("Значение", Автообновление);
	МассивСтруктур.Добавить(Элемент);
	
	Элемент = Новый Структура;
	Элемент.Вставить("Объект", "ИнтеграцияС1СДокументооборот");
	Элемент.Вставить("Настройка", "ПериодАвтообновления");
	Элемент.Вставить("Значение", ПериодАвтообновления);
	МассивСтруктур.Добавить(Элемент);
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур);
	
	Если Автообновление Тогда
		ПодключитьОбработчикОжидания("Автообновление", ПериодАвтообновления);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПринятьЗадачиКИсполнению()
	
	Модифицированность = Ложь;
	МассивСтрок = Элементы.ЗадачиМне.ВыделенныеСтроки;
	Если МассивСтрок.Количество() <> 0 Тогда
		МассивЗадачДО = Новый Массив;
		Для Каждого Элемент Из МассивСтрок Цикл
			СтрокаЗадачи = ЗадачиМне.НайтиПоИдентификатору(Элемент);
			Если ЗначениеЗаполнено(СтрокаЗадачи.ЗадачаID) Тогда
				МассивЗадачДО.Добавить(СтрокаЗадачи.ЗадачаID);
			КонецЕсли;
		КонецЦикла;
		Если МассивЗадачДО.Количество() > 0 Тогда
			Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
			ИнтеграцияС1СДокументооборот.ПринятьЗадачуКИсполнению(Прокси, МассивЗадачДО);
			ОбновитьСписокЗадачЧастичноНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОтменитьПринятиеЗадачКИсполнению()
	
	Модифицированность = Ложь;
	МассивСтрок = Элементы.ЗадачиМне.ВыделенныеСтроки;
	Если МассивСтрок.Количество() <> 0 Тогда
		МассивЗадачДО = Новый Массив;
		Для Каждого Элемент Из МассивСтрок Цикл
			СтрокаЗадачи = ЗадачиМне.НайтиПоИдентификатору(Элемент);
			Если ЗначениеЗаполнено(СтрокаЗадачи.ЗадачаID) Тогда
				МассивЗадачДО.Добавить(СтрокаЗадачи.ЗадачаID);
			КонецЕсли;
		КонецЦикла;
		Если МассивЗадачДО.Количество() > 0 Тогда
			Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
			ИнтеграцияС1СДокументооборот.ОтменитьПринятиеЗадачКИсполнению(Прокси, МассивЗадачДО);
			ОбновитьСписокЗадачЧастичноНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОформлениеЗадач(УсловноеОформление)
	
	// установка оформления для просроченных задач мне
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиМне.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиМне.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиМне.Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  Метаданные.ЭлементыСтиля.ПросроченныеДанныеЦвет.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("ЗадачиМне");
	
	// установка оформления для просроченных задач от меня
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиОтМеня.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиОтМеня.СрокИсполнения");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ЭлементОтбораДанных.ПравоеЗначение = НачалоДня(ТекущаяДатаСеанса());
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементОтбораДанных = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбораДанных.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗадачиОтМеня.Выполнена");
	ЭлементОтбораДанных.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораДанных.ПравоеЗначение = Ложь;
	ЭлементОтбораДанных.Использование = Истина;
	
	ЭлементЦветаОформления = ЭлементУсловногоОформления.Оформление.Элементы.Найти("TextColor");
	ЭлементЦветаОформления.Значение =  Метаданные.ЭлементыСтиля.ПросроченныеДанныеЦвет.Значение; 
	ЭлементЦветаОформления.Использование = Истина;
	
	ЭлементОбластиОформления = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ЭлементОбластиОформления.Поле = Новый ПолеКомпоновкиДанных("ЗадачиОтМеняСрокИсполнения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадачЧастично()
	
	ОбновитьСписокЗадачЧастичноНаСервере();
	РазвернутьГруппыЗадач();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗадачиМне(Прокси, Выполненные)
	
	СписокУсловий = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	УсловияОтбора = СписокУсловий.conditions; // СписокXDTO
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "byUser";
	Условие.value = Истина;
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withExecuted";
	Условие.value = Выполненные;
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withDelayed";
	Условие.value = Ложь;
	УсловияОтбора.Добавить(Условие);
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMBusinessProcessTask",
		СписокУсловий);
	
	Возврат Ответ.items;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗадачиОтМеня(Прокси, Выполненные)
	
	СписокУсловий = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListQuery");
	УсловияОтбора = СписокУсловий.conditions; // СписокXDTO
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "author";
	Условие.value = "";
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withExecuted";
	Условие.value = Выполненные;
	УсловияОтбора.Добавить(Условие);
	
	Условие = ИнтеграцияС1СДокументооборотБазоваяФункциональность.СоздатьОбъект(Прокси, "DMObjectListCondition");
	Условие.property = "withDelayed";
	Условие.value = Ложь;
	УсловияОтбора.Добавить(Условие);
	
	Ответ = ИнтеграцияС1СДокументооборотБазоваяФункциональность.НайтиСписокОбъектов(
		Прокси,
		"DMBusinessProcessTask",
		СписокУсловий);
	
	Возврат Ответ.items;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокЗадач(ЗадачиXDTO)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ИмяСпискаЗадач =  "ЗадачиМне";
		РежимГруппировки = РежимГруппировкиЗадачиМне;
		ТекущаяЗадача = Элементы.ЗадачиМне.ТекущаяСтрока;
		Если ТекущаяЗадача <> Неопределено Тогда
			СтрокаТекущейЗадачи = ЗадачиМне.НайтиПоИдентификатору(ТекущаяЗадача);
			Если СтрокаТекущейЗадачи = Неопределено Тогда
				ТекущаяЗадача = Неопределено;
			Иначе
				ТекущаяЗадача = СтрокаТекущейЗадачи.ЗадачаID;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ИмяСпискаЗадач =  "ЗадачиОтМеня";
		РежимГруппировки = РежимГруппировкиЗадачиОтМеня;
		ТекущаяЗадача = Элементы.ЗадачиОтМеня.ТекущаяСтрока;
		Если ТекущаяЗадача <> Неопределено Тогда
			СтрокаТекущейЗадачи = ЗадачиОтМеня.НайтиПоИдентификатору(ТекущаяЗадача);
			Если СтрокаТекущейЗадачи = Неопределено Тогда
				ТекущаяЗадача = Неопределено;
			Иначе
				ТекущаяЗадача = СтрокаТекущейЗадачи.ЗадачаID;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Дерево = РеквизитФормыВЗначение(ИмяСпискаЗадач); // ДеревоЗначений
	
	ТаблицаЗадач = Новый ТаблицаЗначений;
	Для Каждого Колонка Из Дерево.Колонки Цикл
		ТаблицаЗадач.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
	КонецЦикла;
	
	Для Каждого ЗадачаXDTO Из ЗадачиXDTO Цикл
		СтрокаЗадачи = ТаблицаЗадач.Добавить();
		ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи, ЗадачаXDTO.object);
	КонецЦикла;
	Дерево.Строки.Очистить();
	
	Если ЗначениеЗаполнено(РежимГруппировки) Тогда
		Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Дерево;
		ТаблицаГруппировок = ТаблицаЗадач.Скопировать();
		ТаблицаГруппировок.Свернуть(РежимГруппировки);
		Для Каждого СтрокаГруппировки Из ТаблицаГруппировок Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			СтрокаДерева.Задача = СтрокаГруппировки[РежимГруппировки];
			СтрокаДерева.КартинкаЗадачи = 2;
			СтрокаДерева.Важность = 1;
			СтрокаДерева.Группировка = Истина;
			СтрокиГруппировки = ТаблицаЗадач.НайтиСтроки(Новый Структура(РежимГруппировки,СтрокаГруппировки[РежимГруппировки]));
			Для Каждого Строка Из СтрокиГруппировки Цикл
				СтрокаЭлемента = СтрокаДерева.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаЭлемента,Строка);
				СтрокаДерева.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
			КонецЦикла;
		КонецЦикла;
		Дерево.Строки.Сортировать("Задача");
	Иначе
		Элементы[ИмяСпискаЗадач].Отображение = ОтображениеТаблицы.Список;
		Для Каждого Строка Из ТаблицаЗадач Цикл
			СтрокаДерева = Дерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаДерева,Строка);
		КонецЦикла;
		Дерево.Строки.Сортировать("СрокИсполнения УБЫВ, Задача");
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(Дерево, ИмяСпискаЗадач);
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачМнеСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
		ЗадачиМнеСчитаны = Истина;
	Иначе
		ТаблицаЗадачОтМеняСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
		ЗадачиОтМеняСчитаны = Истина;
	КонецЕсли;
	
	УстановитьТекущуюСтроку(ТекущаяЗадача);
	
	ЗаполнитьДекорацииЧислаЗадач();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДекорацииЧислаЗадач()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачСсылка = ТаблицаЗадачМнеСсылка;
	Иначе
		Возврат;
	КонецЕсли;
	
	Просрочено = 0;
	НеПринято = 0;
	ТекущаяДата = ТекущаяДатаСеанса();
	ТаблицаЗадач = ПолучитьИзВременногоХранилища(ТаблицаЗадачСсылка); // ТаблицаЗначений
	НеВыполненныеЗадачи = ТаблицаЗадач.НайтиСтроки(Новый Структура("Выполнена", Ложь));
	
	Для Каждого СтрокаЗадачи Из НеВыполненныеЗадачи Цикл
		Если ЗначениеЗаполнено(СтрокаЗадачи.СрокИсполнения) И СтрокаЗадачи.СрокИсполнения < ТекущаяДата Тогда
			Просрочено = Просрочено + 1;
		КонецЕсли;
		Если Не СтрокаЗадачи.ПринятаКИсполнению Тогда
			НеПринято = НеПринято + 1;
		КонецЕсли;
	КонецЦикла;
		
	Элементы.ДекорацияОбщееЧислоЗадачМне.Заголовок = НеВыполненныеЗадачи.Количество();
	Элементы.ДекорацияЧислоПросроченныхЗадачМне.Заголовок = Просрочено;
	Элементы.ДекорацияЧислоНепринятыхЗадачМне.Заголовок = НеПринято;
	Элементы.ДекорацияРазделительЧислаЗадачМне1.Заголовок = "/";
	Элементы.ДекорацияРазделительЧислаЗадачМне2.Заголовок = "/";
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи, ЗадачаXDTO)
	
	Важность = 1;
	Если ЗадачаXDTO.importance.objectID.ID = "Низкая" Тогда //@NON-NLS-1
		Важность = 0;
	ИначеЕсли ЗадачаXDTO.importance.objectID.ID = "Обычная" Тогда //@NON-NLS-1
		Важность = 1;
	ИначеЕсли ЗадачаXDTO.importance.objectID.ID = "Высокая" Тогда //@NON-NLS-1
		Важность = 2;
	КонецЕсли;
	
	СтрокаЗадачи.Важность = Важность;
	СтрокаЗадачи.ВажностьСтрокой = ЗадачаXDTO.importance.name;
	СтрокаЗадачи.КартинкаЗадачи = ?(ЗадачаXDTO.executed,1,0);
	СтрокаЗадачи.Выполнена = ЗадачаXDTO.executed;
	СтрокаЗадачи.ТочкаМаршрута = ЗадачаXDTO.businessProcessStep;
	СтрокаЗадачи.СрокИсполнения = ЗадачаXDTO.dueDate;
	СтрокаЗадачи.Записана = ЗадачаXDTO.beginDate;
	СтрокаЗадачи.Автор = ЗадачаXDTO.author.name;
	СтрокаЗадачи.ПринятаКИсполнению = ЗадачаXDTO.accepted;
	
	ИсполнительXDTO = ЗадачаXDTO.performer;
	Если ИсполнительXDTO.Установлено("user") Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи, ИсполнительXDTO.user,"Исполнитель")
	ИначеЕсли ИсполнительXDTO.Установлено("role") Тогда
		ИнтеграцияС1СДокументооборотБазоваяФункциональность.ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи, ИсполнительXDTO.role,"Исполнитель")
	КонецЕсли;
	
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.parentBusinessProcess,"Процесс");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO.target,"Предмет");
	ЗаполнитьОбъектныйРеквизит(СтрокаЗадачи,ЗадачаXDTO,"Задача");
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ЗадачиXDTO = ПолучитьЗадачиМне(Прокси, Выполненные);
	Иначе
		ЗадачиXDTO = ПолучитьЗадачиОтМеня(Прокси, Выполненные);
	КонецЕсли;
	ЗаполнитьСписокЗадач(ЗадачиXDTO);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачЧастичноНаСервере()
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачСсылка = ТаблицаЗадачМнеСсылка;
	Иначе
		ТаблицаЗадачСсылка = ТаблицаЗадачОтМеняСсылка;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТаблицаЗадачСсылка) Тогда
		ОбновитьСписокЗадачНаСервере();
		Возврат;
	КонецЕсли;
	
	Прокси = ИнтеграцияС1СДокументооборотБазоваяФункциональностьПовтИсп.ПолучитьПрокси();
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ЗадачиXDTO = ПолучитьЗадачиМне(Прокси, Выполненные);
	Иначе
		ЗадачиXDTO = ПолучитьЗадачиОтМеня(Прокси, Выполненные);
	КонецЕсли;
	
	ТаблицаЗадач = ПолучитьИзВременногоХранилища(ТаблицаЗадачСсылка); // ТаблицаЗначений
	ЗадачиКУдалению = ТаблицаЗадач.ВыгрузитьКолонку("ЗадачаID");
	
	Для Каждого ЗадачаXDTO Из ЗадачиXDTO Цикл
		СтрокиЗадач = ТаблицаЗадач.НайтиСтроки(Новый Структура("ЗадачаID",ЗадачаXDTO.object.objectID.ID));
		Если СтрокиЗадач.Количество() > 0 Тогда
			СтрокаЗадачи = СтрокиЗадач[0];
			ЗадачиКУдалению.Удалить(ЗадачиКУдалению.Найти(ЗадачаXDTO.object.objectID.ID));
		Иначе
			СтрокаЗадачи = ТаблицаЗадач.Добавить();
		КонецЕсли;
		ЗаполнитьСтрокуЗадачиXDTO(СтрокаЗадачи,ЗадачаXDTO.object);
	КонецЦикла;
	
	Для Каждого УдаляемаяЗадача Из ЗадачиКУдалению Цикл
		СтрокиЗадач = ТаблицаЗадач.НайтиСтроки(Новый Структура("ЗадачаID", УдаляемаяЗадача));
		Если СтрокиЗадач.Количество() > 0 Тогда
			ТаблицаЗадач.Удалить(СтрокиЗадач[0]);
		КонецЕсли;
	КонецЦикла;
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаЗадачиМне Тогда
		ТаблицаЗадачМнеСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
		СгруппироватьПоКолонкеНаСервере(РежимГруппировкиЗадачиМне);
	Иначе
		ТаблицаЗадачОтМеняСсылка = ПоместитьВоВременноеХранилище(ТаблицаЗадач, УникальныйИдентификатор);
		СгруппироватьПоКолонкеНаСервере(РежимГруппировкиЗадачиОтМеня);
	КонецЕсли;
	
	ЗаполнитьДекорацииЧислаЗадач();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОбъектныйРеквизит(Приемник, Источник, ИмяРеквизита)
	
	Если Источник <> Неопределено Тогда
		Приемник[ИмяРеквизита] = Источник.name;
		Приемник[ИмяРеквизита + "ID"] = Источник.objectID.ID;
		Приемник[ИмяРеквизита + "Тип"] = Источник.objectID.type;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти