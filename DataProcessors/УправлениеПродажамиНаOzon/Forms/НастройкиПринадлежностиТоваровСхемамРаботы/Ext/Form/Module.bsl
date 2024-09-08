﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УчетнаяЗаписьТорговойПлощадки = Параметры.УчетнаяЗаписьТорговойПлощадки;
	ИсточникКатегории = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(УчетнаяЗаписьТорговойПлощадки, "ИсточникКатегории");

	FBO = Истина; // Схема продаж со складов торговой площадки используется всегда

	УстановитьУсловноеОформление();

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	ОтборПоКатегорииПриИзменении(Элементы.ОтборПоКатегории);
	ОбновитьПараметрыСпискаТоваров();
	ПриИзмененииОтборовСпискаТоваров();

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	Если ИмяСобытия = "ИсточникКатегорииИзменен" Тогда
		ОчиститьСообщения();

		УчетнаяЗаписьИзменения     = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметр, "УчетнаяЗаписьМаркетплейса", ПредопределенноеЗначение("Справочник.УчетныеЗаписиМаркетплейсов.ПустаяСсылка"));
		ИсточникКатегорииИзменения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметр, "ИсточникКатегории", ПредопределенноеЗначение("Перечисление.ИсточникиКатегорийДляМаркетплейса.ПустаяСсылка"));

		Если УчетнаяЗаписьТорговойПлощадки = УчетнаяЗаписьИзменения И ИсточникКатегории <> ИсточникКатегорииИзменения Тогда
			ИсточникКатегории = ИсточникКатегорииИзменения;
			ОбновитьПараметрыСпискаТоваров();
			Элементы.СписокТоваров.Обновить();
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)

	Если ОтборПоКатегории = 0 Тогда
		Элементы.СтраницыКоманд.ТекущаяСтраница = Элементы.СтраницаКомандКатегорий1С;
	Иначе
		Элементы.СтраницыКоманд.ТекущаяСтраница = Элементы.СтраницаКомандКатегорийМаркетплейса;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПоКатегорииПриИзменении(Элемент)

	ЭтоОтборПоКатегории1С = (ОтборПоКатегории = 0);
	Элементы.ИсточникКатегории.Видимость = ЭтоОтборПоКатегории1С;

	ТекущаяСтраница = Элементы.СтраницыКоманд.ТекущаяСтраница;
	Если ЭтоОтборПоКатегории1С Тогда
		Элементы.СтраницыКоманд.ТекущаяСтраница = Элементы.СтраницаКомандКатегорий1С;
	Иначе
		Элементы.СтраницыКоманд.ТекущаяСтраница = Элементы.СтраницаКомандКатегорийМаркетплейса;
	КонецЕсли;

	Если Элементы.СтраницыКоманд.ТекущаяСтраница <> ТекущаяСтраница Тогда
		СписокКатегорийОтбора.Очистить();
	КонецЕсли;

	ИзменитьОтборПоКатегории(СписокКатегорийОтбора.Количество() = 0);

	Элементы.СписокКатегорийОтбораКонтекстноеМенюДобавить.Доступность = ЭтоОтборПоКатегории1С;
	Элементы.СписокКатегорийОтбораКонтекстноеМенюПодбор.Видимость     = ЭтоОтборПоКатегории1С;

	ИзменитьПросмотр = Ложь;
	Если ЭтоОтборПоКатегории1С И ИсточникКатегории = ПредопределенноеЗначение("Перечисление.ИсточникиКатегорийДляМаркетплейса.ИерархияНоменклатуры") Тогда
		ТипЗначения = "СправочникСсылка.Номенклатура";
		Если Элементы.СписокКатегорийОтбора.ТолькоПросмотр Тогда
			ИзменитьПросмотр = Истина;
		КонецЕсли;
	ИначеЕсли ЭтоОтборПоКатегории1С И ИсточникКатегории = ПредопределенноеЗначение("Перечисление.ИсточникиКатегорийДляМаркетплейса.ВидНоменклатуры") Тогда
		ТипЗначения = "СправочникСсылка.ВидыНоменклатуры";
		Если Элементы.СписокКатегорийОтбора.ТолькоПросмотр Тогда
			ИзменитьПросмотр = Истина;
		КонецЕсли;
	ИначеЕсли ЭтоОтборПоКатегории1С И ИсточникКатегории = ПредопределенноеЗначение("Перечисление.ИсточникиКатегорийДляМаркетплейса.ТоварнаяКатегория") Тогда
		ТипЗначения = "СправочникСсылка.ТоварныеКатегории";
		Если Элементы.СписокКатегорийОтбора.ТолькоПросмотр Тогда
			ИзменитьПросмотр = Истина;
		КонецЕсли;
	ИначеЕсли НЕ ЭтоОтборПоКатегории1С Тогда
		ТипЗначения = "Строка";
		Если Элементы.СписокКатегорийОтбора.ТолькоПросмотр Тогда
			ИзменитьПросмотр = Истина;
		КонецЕсли;
	Иначе
		ТипЗначения = "Неопределено";
		Если НЕ Элементы.СписокКатегорийОтбора.ТолькоПросмотр Тогда
			ИзменитьПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;

	СписокКатегорийОтбора.ТипЗначения = Новый ОписаниеТипов(ТипЗначения);

	Если ИзменитьПросмотр Тогда
		Элементы.СписокКатегорийОтбора.ТолькоПросмотр = НЕ Элементы.СписокКатегорийОтбора.ТолькоПросмотр;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокТоваров

&НаКлиенте
Процедура СписокТоваровВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)

	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Поле = Элементы.СписокТоваровПометка Тогда
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные.Пометка = НЕ ТекущиеДанные.Пометка;
		УстановитьПометку(ТекущиеДанные.Пометка, ТекущиеДанные.ИдентификаторПубликации);

		ОбновитьПараметрыСпискаТоваров();
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокКатегорийОтбора

&НаКлиенте
Процедура СписокКатегорийОтбораОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;

	Для Каждого Значение Из ВыбранноеЗначение Цикл
		Если СписокКатегорийОтбора.НайтиПоЗначению(Значение) = Неопределено Тогда
			СписокКатегорийОтбора.Добавить(Значение);
		КонецЕсли;
	КонецЦикла;

	ИзменитьПометкуОтбора(ВыбранноеЗначение);

	ИзменитьОтборПоКатегории(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура СписокКатегорийОтбораПриИзменении(Элемент)

	ТекущиеДанные = Элемент.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено И ЗначениеЗаполнено(ТекущиеДанные.Значение) Тогда
		ИзменитьОтборПоКатегории(Ложь);
	ИначеЕсли СписокКатегорийОтбора.Количество() = 0 Тогда
		ИзменитьОтборПоКатегории(Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокКатегорийОтбораПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)

	Если ОтборПоКатегории <> 0 Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокКатегорийОтбораПередНачаломИзменения(Элемент, Отказ)

	Если ОтборПоКатегории <> 0 Тогда
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокКатегорийОтбораЗначениеПриИзменении(Элемент)

	ТекущиеДанные = Элементы.СписокКатегорийОтбора.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено ИЛИ НЕ ЗначениеЗаполнено(ТекущиеДанные.Значение) ИЛИ ОтборПоКатегории <> 0 Тогда
		Возврат;
	КонецЕсли;

	ИзменитьПометкуОтбора(Элементы.СписокКатегорийОтбора.ТекущаяСтрока);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьПометки(Команда)

	УстановитьПометку(Истина);

КонецПроцедуры

&НаКлиенте
Процедура СнятьПометки(Команда)

	УстановитьПометку(Ложь);

КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкуОтборовСписка(Команда)

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ИсточникДоступныхНастроек", СписокТоваров.КомпоновщикНастроек.ПолучитьИсточникДоступныхНастроек());
	ПараметрыФормы.Вставить("Настройки",                 СписокТоваров.КомпоновщикНастроек.Настройки);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", СписокТоваров.КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("ФиксированныеНастройки",    СписокТоваров.КомпоновщикНастроек.ФиксированныеНастройки);

	Оповещение = Новый ОписаниеОповещения("ПриОкончанииНастройкиСпискаТоваров", ЭтотОбъект);

	ОткрытьФорму("Справочник.УчетныеЗаписиМаркетплейсов.Форма.НастройкаОтборовСписка", ПараметрыФормы, ЭтотОбъект,,,, Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиДляВыбранныхПозиций(Команда)

	ОчиститьСообщения();

	Если НЕ ЭтоУстановкаПометокДляВсехПозиций И ИдентификаторыПубликацииВыбранные.Количество() = 0 Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Не найдены отмеченные позиции для установки настроек.'"));
		Возврат;
	КонецЕсли;

	ДлительнаяОперация    = ВызовЗаданияУстановкиНастроекНаСервере();
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьДанныеФормыНаКлиенте", ЭтотОбъект);

	Если ДлительнаяОперация.Статус = "Выполнено" Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗавершении, ДлительнаяОперация);
	Иначе
		ПараметрыОжидания                                  = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания             = Истина;
		ПараметрыОжидания.ТекстСообщения                   = НСтр("ru = 'Установка настроек для товаров по схемам работы'");
		ПараметрыОжидания.ОповещениеПользователя.Показать  = Истина;
		ПараметрыОжидания.ОповещениеПользователя.Текст     = НСтр("ru = 'Ozon'");
		ПараметрыОжидания.ОповещениеПользователя.Пояснение = НСтр("ru = 'Завершена установка настроек для товаров по схемам работы.'");
		ПараметрыОжидания.ОповещениеПользователя.Картинка  = БиблиотекаКартинок.ЛоготипOzon2;

		ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодобратьКатегорииМаркетплейса(Команда)

	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыборКатегорийТорговойПлощадкиЗавершение", ЭтотОбъект);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("УчетнаяЗаписьТорговойПлощадки", УчетнаяЗаписьТорговойПлощадки);
	ПараметрыФормы.Вставить("ВыбранныеКатегории",            СписокКатегорийОтбора);
	ОткрытьФорму("Обработка.УправлениеПродажамиНаOzon.Форма.МножественныйВыборКатегорийТорговойПлощадки", ПараметрыФормы,
		,,,, ОповещениеОЗакрытии);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	//

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокТоваровКатегория1С.Имя);
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокТоваровИсточникКатегории.Имя);

	ЭлементУсловия = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементУсловия.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокТоваров.ПредставлениеНесоответствияИсточникуКатегории");
	ЭлементУсловия.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;

	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПоясняющийОшибкуТекст);

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОтборовСпискаТоваров()

	ЗаголовокОтбора = "еще...";
	СчетчикОтборов = 0;

	Для Каждого НастройкиОтбора Из СписокТоваров.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		Для Каждого ЭлементОтбора Из НастройкиОтбора.Элементы Цикл
			Если ЭлементОтбора.Использование Тогда
				СчетчикОтборов = СчетчикОтборов + 1;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;

	Если СчетчикОтборов > 0 Тогда
		ЗаголовокОтбора = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'и еще %1'"), СчетчикОтборов);
	КонецЕсли;

	Элементы.ОткрытьНастройкуОтборовСписка.Заголовок = ЗаголовокОтбора;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьПересеченияПользовательскихИВнутреннихОтборов()

	ИсключаемыеПользовательскиеОтборы = Новый Массив;
	ИсключаемыеПользовательскиеОтборы.Добавить(Новый ПолеКомпоновкиДанных("УчетнаяЗаписьМаркетплейса"));
	ИсключаемыеПользовательскиеОтборы.Добавить(Новый ПолеКомпоновкиДанных("ВидОбъектаМаркетплейса"));

	Для Каждого КоллекцияНастроек Из СписокТоваров.КомпоновщикНастроек.ПользовательскиеНастройки.Элементы Цикл
		МассивНастроекКУдалению = Новый Массив;
		Для Каждого ЭлементНастройки Из КоллекцияНастроек.Элементы Цикл
			Если ИсключаемыеПользовательскиеОтборы.Найти(ЭлементНастройки.ЛевоеЗначение) = Неопределено Тогда
				Продолжить;
			КонецЕсли;

			МассивНастроекКУдалению.Добавить(ЭлементНастройки);
		КонецЦикла;

		Для Каждого ЭлементНастройки Из МассивНастроекКУдалению Цикл
			КоллекцияНастроек.Элементы.Удалить(ЭлементНастройки);
		КонецЦикла;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометку(Пометка, ИдентификаторПубликации = "")

	Если ПустаяСтрока(ИдентификаторПубликации) Тогда
		ИдентификаторыПубликацииВыбранные.Очистить();
		ИдентификаторыПубликацииИсключенные.Очистить();
		ЭтоУстановкаПометокДляВсехПозиций = Пометка;

		ОбновитьПараметрыСпискаТоваров();
		Элементы.СписокТоваров.Обновить();
		
	Иначе
		ИндексПозицииДобавления = ИдентификаторыПубликацииВыбранные.НайтиПоЗначению(ИдентификаторПубликации);
		ИндексПозицииУдаления   = ИдентификаторыПубликацииИсключенные.НайтиПоЗначению(ИдентификаторПубликации);

		Если Пометка Тогда
			ЭтоУстановкаПометокДляВсехПозиций = Ложь;

			Если ИндексПозицииУдаления <> Неопределено Тогда
				ИдентификаторыПубликацииИсключенные.Удалить(ИндексПозицииУдаления);
			Иначе
				ИдентификаторыПубликацииВыбранные.Добавить(ИдентификаторПубликации);
			КонецЕсли;
		Иначе
			Если ИндексПозицииДобавления <> Неопределено Тогда
				ИдентификаторыПубликацииВыбранные.Удалить(ИндексПозицииДобавления);
			Иначе
				ИдентификаторыПубликацииИсключенные.Добавить(ИдентификаторПубликации);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОкончанииНастройкиСпискаТоваров(Настройки, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(Настройки) <> Тип("ПользовательскиеНастройкиКомпоновкиДанных") Тогда
		Возврат;
	КонецЕсли;

	СписокТоваров.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(Настройки);

	ИдентификаторыПубликацииВыбранные.Очистить();
	ИдентификаторыПубликацииИсключенные.Очистить();
	ОбновитьПараметрыСпискаТоваров();

	ОбработатьПересеченияПользовательскихИВнутреннихОтборов();

	ПриИзмененииОтборовСпискаТоваров();

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПараметрыСпискаТоваров()

	СписокТоваров.Параметры.УстановитьЗначениеПараметра("УчетнаяЗаписьТорговойПлощадки", УчетнаяЗаписьТорговойПлощадки); 
	СписокТоваров.Параметры.УстановитьЗначениеПараметра("ИсточникКатегории", ИсточникКатегории); 
	СписокТоваров.Параметры.УстановитьЗначениеПараметра("ПредставлениеНесоответствияИсточникуКатегории", НСтр("ru = '(не соответствует текущему источнику категории)'")); 
	СписокТоваров.Параметры.УстановитьЗначениеПараметра("ЭтоУстановкаПометокДляВсехПозиций", ЭтоУстановкаПометокДляВсехПозиций);
	СписокТоваров.Параметры.УстановитьЗначениеПараметра("ИдентификаторыПубликацииВыбранные", ИдентификаторыПубликацииВыбранные.ВыгрузитьЗначения());
	СписокТоваров.Параметры.УстановитьЗначениеПараметра("ИдентификаторыПубликацииИсключенные", ИдентификаторыПубликацииИсключенные.ВыгрузитьЗначения());

КонецПроцедуры

&НаКлиенте
Процедура ВыборКатегорийТорговойПлощадкиЗавершение(ВыбранныеКатегории, ДополнительныеПараметры = Неопределено) Экспорт

	Если ВыбранныеКатегории <> Неопределено Тогда
		СписокКатегорийОтбора = ВыбранныеКатегории;

		Если СписокКатегорийОтбора.Количество() > 0 Тогда
			ИзменитьОтборПоКатегории(Ложь);
		Иначе
			ИзменитьОтборПоКатегории(Истина);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИзменитьОтборПоКатегории(УдалитьОтбор)

	ЭтоОтборПоКатегории1С = (ОтборПоКатегории = 0);

	ПараметрОтбораКУдалению  = ?(ЭтоОтборПоКатегории1С, "СписокКатегорийМаркетплейса", "СписокКатегорий1С");
	ПараметрОтбораКУстановке = ?(ЭтоОтборПоКатегории1С, "СписокКатегорий1С", "СписокКатегорийМаркетплейса");

	Использование = Ложь;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокТоваров, ПараметрОтбораКУдалению, Новый СписокЗначений, Использование);

	Если УдалитьОтбор Тогда
		ЗначениеОтбора = Новый СписокЗначений;
	Иначе
		ЗначениеОтбора = СписокКатегорийОтбора;
		Использование = Истина;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(СписокТоваров, ПараметрОтбораКУстановке, ЗначениеОтбора, Использование);

КонецПроцедуры

&НаСервере
Процедура ИзменитьПометкуОтбора(ВыбранноеЗначение)

	Если ТипЗнч(ВыбранноеЗначение) = Тип("Число") Тогда
		ТекущиеДанные = СписокКатегорийОтбора.НайтиПоИдентификатору(ВыбранноеЗначение);
		ТекущиеДанные.Пометка = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущиеДанные.Значение, "ЭтоГруппа");
	Иначе
		ДанныеОПометках = ОбщегоНазначения.ЗначениеРеквизитаОбъектов(ВыбранноеЗначение, "ЭтоГруппа");
		Для Каждого ДанныеОПометке Из ДанныеОПометках Цикл
			ТекущиеДанные = СписокКатегорийОтбора.НайтиПоЗначению(ДанныеОПометке.Ключ);
			Если ТекущиеДанные <> Неопределено Тогда
				ТекущиеДанные.Пометка = ДанныеОПометке.Значение;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ВызовЗаданияУстановкиНастроекНаСервере()

	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияФункции(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Ozon. Установка настроек для товаров по схемам работы'");
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.ЗапуститьВФоне = Истина;

	СписокИсточника = Элементы.СписокТоваров;

	ПараметрыКомпоновщикаНастроек = ПараметрыУстановкиНастроек();
	ПараметрыКомпоновщикаНастроек.НастройкиКомпоновкиДанных         = СписокИсточника.ПолучитьИсполняемыеНастройкиКомпоновкиДанных();
	ПараметрыКомпоновщикаНастроек.СхемаКомпоновкиДанных             = СписокИсточника.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	ПараметрыКомпоновщикаНастроек.ЭтоУстановкаПометокДляВсехПозиций = ЭтоУстановкаПометокДляВсехПозиций;

	Если ЭтоУстановкаПометокДляВсехПозиций Тогда
		ПараметрыКомпоновщикаНастроек.Вставить("ИдентификаторыПубликацииИсключенные", ИдентификаторыПубликацииИсключенные);
	Иначе
		ПараметрыКомпоновщикаНастроек.Вставить("ИдентификаторыПубликацииВыбранные", ИдентификаторыПубликацииВыбранные);
	КонецЕсли;

	// Добавить все выбранные поля, т.к. для пользователя выводятся не все поля динамического списка.
	Для Каждого ПолеВыбора Из СписокТоваров.КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных("ПараметрыДанных") Тогда
			Продолжить;
		КонецЕсли;

		Для Каждого СтрокаСтруктуры Из ПараметрыКомпоновщикаНастроек.НастройкиКомпоновкиДанных.Структура Цикл
			КомпоновкаДанныхКлиентСервер.ДобавитьВыбранноеПоле(СтрокаСтруктуры.Выбор, ПолеВыбора.Поле, ПолеВыбора.Заголовок);
		КонецЦикла;
	КонецЦикла;

	ПараметрыКомпоновщикаНастроек.НастройкиПоСхемамРаботы.ПродаетсяПоСхемеРаботыFBS = FBS;
	ПараметрыКомпоновщикаНастроек.НастройкиПоСхемамРаботы.ПродаетсяПоСхемеРаботыDBS = RealFBS;

	// Установить параметры для отмеченных или снятых с пометки позиций.
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПараметрыКомпоновщикаНастроек.НастройкиКомпоновкиДанных, "ИдентификаторыПубликацииВыбранные",
		ИдентификаторыПубликацииВыбранные);
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(ПараметрыКомпоновщикаНастроек.НастройкиКомпоновкиДанных, "ИдентификаторыПубликацииИсключенные",
		ИдентификаторыПубликацииИсключенные);

	ИмяМетода = "ИнтеграцияСМаркетплейсомOzonСервер.УстановитьНастройкиДляТоваровПоСхемамРаботы";

	Возврат ДлительныеОперации.ВыполнитьФункцию(ПараметрыВыполнения, ИмяМетода,
		УчетнаяЗаписьТорговойПлощадки, ПараметрыКомпоновщикаНастроек);

КонецФункции

&НаСервереБезКонтекста
Функция ПараметрыУстановкиНастроек()

	ПараметрыКомпоновщикаНастроек = Новый Структура;
	ПараметрыКомпоновщикаНастроек.Вставить("НастройкиКомпоновкиДанных",           Новый НастройкиКомпоновкиДанных);
	ПараметрыКомпоновщикаНастроек.Вставить("СхемаКомпоновкиДанных",               Новый СхемаКомпоновкиДанных);
	ПараметрыКомпоновщикаНастроек.Вставить("ЭтоУстановкаПометокДляВсехПозиций",   Ложь);
	ПараметрыКомпоновщикаНастроек.Вставить("ИдентификаторыПубликацииВыбранные",   Неопределено);
	ПараметрыКомпоновщикаНастроек.Вставить("ИдентификаторыПубликацииИсключенные", Неопределено);

	НастройкиПоСхемамРаботы = Новый Структура;
	НастройкиПоСхемамРаботы.Вставить("ПродаетсяПоСхемеРаботыFBO", Истина);
	НастройкиПоСхемамРаботы.Вставить("ПродаетсяПоСхемеРаботыFBS", Ложь);
	НастройкиПоСхемамРаботы.Вставить("ПродаетсяПоСхемеРаботыDBS", Ложь);
	ПараметрыКомпоновщикаНастроек.Вставить("НастройкиПоСхемамРаботы",             НастройкиПоСхемамРаботы);

	Возврат ПараметрыКомпоновщикаНастроек;

КонецФункции

&НаКлиенте
Процедура ОбновитьДанныеФормыНаКлиенте(Результат, ДополнительныеПараметры) Экспорт

	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Если Результат.Статус = "Ошибка" Тогда
			ОбщегоНазначенияКлиент.СообщитьПользователю(Результат.ПодробноеПредставлениеОшибки);
		ИначеЕсли Результат.Статус = "Выполнено" 
					И Результат.Свойство("АдресРезультата") Тогда
			ИнформацияОбОшибках = ПолучитьИзВременногоХранилища(Результат.АдресРезультата);

			Если ТипЗнч(ИнформацияОбОшибках) = Тип("Структура") 
						И Не ПустаяСтрока(ИнформацияОбОшибках.КодОшибки) Тогда
				ОбщегоНазначенияКлиент.СообщитьПользователю(ИнформацияОбОшибках.ОписаниеОшибки);
			Иначе
				ИдентификаторыПубликацииВыбранные.Очистить();
				ИдентификаторыПубликацииИсключенные.Очистить();
				ЭтоУстановкаПометокДляВсехПозиций = Ложь;
				
				ОбновитьПараметрыСпискаТоваров();
				Элементы.СписокТоваров.Обновить();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
