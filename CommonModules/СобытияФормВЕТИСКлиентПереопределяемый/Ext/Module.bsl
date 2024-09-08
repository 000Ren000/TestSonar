﻿#Область Локализация

Процедура ПослеЗаписи(Форма, ПараметрыЗаписи) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

#Область СобытияЭлементовФорм

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
// Параметры:
//   Форма                   - ФормаКлиентскогоПриложения - форма, из которой происходит вызов процедуры.
//   Элемент                 - ЭлементФормы     - элемент-источник события "При изменении"
//   ДополнительныеПараметры - Структура        - значения дополнительных параметров влияющих на обработку.
//
Процедура ПриИзмененииЭлемента(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриВыбореЭлемента(Форма, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриАктивизацииЯчейки(Форма, Элемент, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Переопределяемая процедура, вызываемая из одноименного обработчика события элемента.
//
Процедура ПриНачалеРедактирования(Форма, Элемент, НоваяСтрока, Копирование, ДополнительныеПараметры) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры
#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиКоманд

// Открывает форму подбора номенклатуры.
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения   - форма, в которой вызывается команда открытия обработки сопоставления;
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора,
//  ПараметрыПодбора        - Структура          - параметры открытия формы подбора товаров, состав полей определен в функции
//                                                 ИнтеграцияВЕТИСКлиентСерверПереопределяемый.ПараметрыФормыПодбораТоваров.
//
Процедура ОткрытьФормуПодбораНоменклатуры(Форма, ОповещениеПриЗавершении = Неопределено, ПараметрыПодбора = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ПараметрЗаголовок = НСтр("ru = 'Подбор номенклатуры в %Документ%'");
	
	Если ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
		ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", Форма.Объект.Ссылка);
	Иначе
		ТипОбъектаФормыПодбора = ТипЗнч(Форма.Объект.Ссылка);
		Если ТипОбъектаФормыПодбора = Тип("ДокументСсылка.ИнвентаризацияПродукцииВЕТИС") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='инвентаризацию продукции ВетИС'"));
		ИначеЕсли ТипОбъектаФормыПодбора = Тип("ДокументСсылка.ПроизводственнаяОперацияВЕТИС") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='производственную операцию ВетИС'"));
		ИначеЕсли ТипОбъектаФормыПодбора = Тип("ДокументСсылка.ИсходящаяТранспортнаяОперацияВЕТИС") Тогда
			ПараметрЗаголовок = СтрЗаменить(ПараметрЗаголовок, "%Документ%", НСтр("ru='исходящую транспортную операцию ВетИС'"));
		КонецЕсли;
	КонецЕсли;
	
	ОсобенностьУчета = Новый Массив;
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МолочнаяПродукцияПодконтрольнаяВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ЗерноВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.ПродуктыПереработкиЗернаВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ВидыПродукцииИС.МорепродуктыПодконтрольныеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КормаДляЖивотныхПодконтрольныеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МясоПодконтрольноеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КонсервированнаяПродукцияПодконтрольнаяВЕТИС"));
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОсобенностьУчета",                        ОсобенностьУчета);
	ПараметрыФормы.Вставить("РежимПодбораБезКоличественныхПараметров", Истина);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",       Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                  Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах",         Истина);
	ПараметрыФормы.Вставить("СкрыватьКнопкуЗапрашиватьКоличество",     Истина);
	ПараметрыФормы.Вставить("Заголовок",                               ПараметрЗаголовок);
	ПараметрыФормы.Вставить("Дата",                                    Форма.Объект.Дата);
	ПараметрыФормы.Вставить("Документ",                                Форма.Объект.Ссылка);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                  Истина);
	
	Если ПараметрыПодбора <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ПараметрыПодбора);
		
		Если ЗначениеЗаполнено(ПараметрыПодбора.ПараметрыУказанияСерий) Тогда
			ПараметрыФормы.Вставить("Склад",                  ПараметрыПодбора.Склад);
			ПараметрыФормы.Вставить("ПараметрыУказанияСерий", ПараметрыПодбора.ПараметрыУказанияСерий);
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму("Обработка.ПодборТоваровВДокументПродажи.Форма",
				ПараметрыФормы,
				Форма,
				Форма.УникальныйИдентификатор,
				,
				,
				ОповещениеПриЗавершении);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму выбора характеристики номенклатуры.
//
// Параметры:
//  Форма                   - ФормаКлиентскогоПриложения   - форма, в которой вызывается команда выбора номенклатуры,
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура, вызываемая после закрытия формы подбора,
//  ПараметрыХарактеристики - Структура          - параметры создания характеристики номенклатуры из формы выбора.
Процедура ОткрытьФормуВыбораХарактеристикиНоменклатуры(Форма, ОповещениеПриЗавершении, ПараметрыХарактеристики = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ОткрытьФорму("Справочник.ХарактеристикиНоменклатуры.ФормаВыбора", ПараметрыХарактеристики, ЭтотОбъект,,,,
		ОповещениеПриЗавершении, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму выбора характеристики номенклатуры.
//
// Параметры:
//  Форма                 - ФормаКлиентскогоПриложения - форма, в которой вызывается команда выбора номенклатуры,
//  ПараметрыНоменклатуры - (См. ИнтеграцияВЕТИСВызовСервера.ПараметрыНоменклатуры).
Процедура ОткрытьФормуВыбораНоменклатуры(Форма, ПараметрыНоменклатуры = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ПараметрыФормы = Новый Структура;
	
	Если НЕ(ПараметрыНоменклатуры = Неопределено) Тогда
		Если ПараметрыНоменклатуры.Свойство("ШтрихкодВЕТИС") Тогда
			ПараметрыНоменклатуры.Вставить("Штрихкод", ПараметрыНоменклатуры.ШтрихкодВЕТИС);
			ПараметрыНоменклатуры.Удалить("ШтрихкодВЕТИС");
		КонецЕсли;
		ДополнительныеПараметры = ПараметрыНоменклатуры;
	Иначе
		ДополнительныеПараметры = Новый Структура;
	КонецЕсли;
	
	ОсобенностьУчета = Новый Массив;
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МолочнаяПродукцияПодконтрольнаяВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ЗерноВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПродуктыПереработкиЗернаВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МорепродуктыПодконтрольныеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КормаДляЖивотныхПодконтрольныеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МясоПодконтрольноеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КонсервированнаяПродукцияПодконтрольнаяВЕТИС"));
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("ОсобенностьУчета", Новый ФиксированныйМассив(ОсобенностьУчета));
	ПараметрыОтбора.Вставить("ТипНоменклатуры",  ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	
	ПараметрыФормы.Вставить("Отбор",                ПараметрыОтбора);
	ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.Элементы);
	ПараметрыФормы.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора", ПараметрыФормы, Форма);
	//-- НЕ ГОСИС
	Возврат;
	
КонецПроцедуры

// Открывает форму создания номенклатуры.
//
// Параметры:
//  Форма                 - ФормаКлиентскогоПриложения - форма, в которой вызывается команда создания номенклатуры,
//  ПараметрыНоменклатуры - (См. описание ИнтеграцияВЕТИСВызовСервера.ПараметрыНоменклатуры)
//  ЕдиницаИзмеренияВЕТИС - СправочникСсылка.ЕдиницыИзмеренияВЕТИС - единица измерения ВЕТИС, на основании которой 
//                                                                   создается номенклатура.
Процедура ОткрытьФормуСозданияНоменклатуры(Форма, ПараметрыНоменклатуры, ЕдиницаИзмеренияВЕТИС) Экспорт
	
	//++ НЕ ГОСИС
	Если ЗначениеЗаполнено(ЕдиницаИзмеренияВЕТИС)
		И Не ЗначениеЗаполнено(ПараметрыНоменклатуры.ЕдиницаИзмеренияВЕТИС) Тогда
		
		ТекстСообщения = НСтр("ru='Невозможно создать номенклатуру, т.к. не заполнено поле ""Единица измерения"" в карточке единицы измерения ВетИС ""%ЕдиницаИзмеренияВетИС%""'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЕдиницаИзмеренияВетИС%", Строка(ЕдиницаИзмеренияВЕТИС));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
		
	КонецЕсли;
	
	ОсобенностьУчета = Новый Массив;
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МолочнаяПродукцияПодконтрольнаяВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ЗерноВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПродуктыПереработкиЗернаВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МорепродуктыПодконтрольныеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КормаДляЖивотныхПодконтрольныеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МясоПодконтрольноеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КонсервированнаяПродукцияПодконтрольнаяВЕТИС"));
	
	ПараметрыФормы = Новый Структура;
	
	ПараметрыФормы.Вставить("ДополнительныеПараметры", ПараметрыНоменклатуры);
	
	ПараметрыФормы.Вставить("ОсобенностьУчета", ОсобенностьУчета);
	ПараметрыФормы.Вставить("ТипНоменклатуры",  ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	
	ОткрытьФорму("Справочник.Номенклатура.ФормаОбъекта", ПараметрыФормы, Форма);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму создания нового контрагента.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма-владелец.
//  Реквизиты     - Структура        - (См. ИнтеграцияВЕТИСКлиентСервер.РеквизитыСозданияКонтрагента)
//
Процедура ОткрытьФормуСозданияКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	//++ НЕ ГОСИС
	Основание = Новый Структура;
	Основание.Вставить("ИНН",                     Реквизиты.ИНН);
	Основание.Вставить("КПП",                     Реквизиты.КПП);
	Основание.Вставить("Наименование",            СокрЛП(Реквизиты.Наименование));
	Основание.Вставить("СокращенноеНаименование", СокрЛП(Реквизиты.НаименованиеПолное));
	Основание.Вставить("ЮридическийАдрес",        Реквизиты.ЮридическийАдрес);
	
	ПравовыеФормы = Новый Соответствие;
	ПравовыеФормы.Вставить("Общество с ограниченной ответственностью", "ООО");
	ПравовыеФормы.Вставить("Закрытое акционерное общество", "ЗАО");
	ПравовыеФормы.Вставить("Открытое акционерное общество", "ОАО");
	ПравовыеФормы.Вставить("Публичное акционерное общество", "ПАО");
	ПравовыеФормы.Вставить("Акционерное общество", "АО");
	
	Если НЕ ЗначениеЗаполнено(Основание.СокращенноеНаименование) 
		ИЛИ НЕ ЗначениеЗаполнено(СтрЗаменить(Основание.СокращенноеНаименование, "-", "")) 
		ИЛИ ВРег(Основание.СокращенноеНаименование) = "НЕТ" Тогда
		Основание.СокращенноеНаименование = Основание.Наименование;
	КонецЕсли;
	
	Для каждого ПравоваяФорма Из ПравовыеФормы Цикл
		
		Поз = СтрНайти(ВРег(Основание.Наименование), ВРег(ПравоваяФорма.Ключ));
		Если Поз > 0 Тогда
			Основание.Наименование = СокрЛП(
				Лев(Основание.Наименование, Поз - 1)
				+ Сред(Основание.Наименование, Поз + СтрДлина(ПравоваяФорма.Ключ) + 1)
				 + " " + ПравоваяФорма.Значение);
		КонецЕсли;
		
		Поз = СтрНайти(ВРег(Основание.СокращенноеНаименование), ВРег(ПравоваяФорма.Ключ));
		Если Поз > 0 Тогда
			Основание.СокращенноеНаименование = СокрЛП(
				ПравоваяФорма.Значение + " " + 
				Лев(Основание.СокращенноеНаименование, Поз - 1)
				+ Сред(Основание.СокращенноеНаименование, Поз + СтрДлина(ПравоваяФорма.Ключ) + 1));
		КонецЕсли;
		
	КонецЦикла;
	
	Поз = СтрНайти(Основание.Наименование, """");
	Если Поз > 0 И Поз <= 10 Тогда
		Основание.Наименование = СокрП(Сред(Основание.Наименование, Поз)) + " " + СокрП(Лев(Основание.Наименование, Поз-1));
		Основание.Наименование = СтрЗаменить(Основание.Наименование, """", "");
	КонецЕсли;

	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("Основание", Основание);
	
	ОткрытьФорму(ПартнерыИКонтрагентыВызовСервера.ИмяФормыСозданияКонтрагента(), ПараметрыФормы, ФормаВладелец);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Открывает форму выбора контрагента.
//
// Параметры:
//  ФормаВладелец - ФормаКлиентскогоПриложения - форма, из которой осуществляется выбор.
//  Реквизиты     - Структура        - данные для заполнения отбора:
//   * Наименование            - Строка - наименование контрагента,
//   * СокращенноеНаименование - Строка - сокращенное наименование контрагента,
//   * ИНН                     - Строка - ИНН контрагента,
//   * КПП                     - Строка - КПП контрагента.
Процедура ОткрытьФормуВыбораКонтрагента(ФормаВладелец, Реквизиты) Экспорт
	
	//++ НЕ ГОСИС
	Основание = Новый Структура;
	Основание.Вставить("ИНН",                     Реквизиты.ИНН);
	Основание.Вставить("КПП",                     Реквизиты.КПП);
	Основание.Вставить("Наименование",            Реквизиты.Наименование);
	Основание.Вставить("СокращенноеНаименование", Реквизиты.СокращенноеНаименование);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Основание", Основание);
	
	ОткрытьФорму("Справочник.Контрагенты.ФормаВыбора", ПараметрыФормы, ФормаВладелец);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Выполняет действия при изменении номенклатуры в таблице Товары.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения            - форма, в которой произошло событие.
//  ТекущаяСтрока          - ДанныеФормыЭлементКоллекции - строка таблицы товаров.
//  КэшированныеЗначения   - Структура                   - сохраненные значения параметров, используемых при обработке строки таблицы.
//  ПараметрыЗаполнения    - см. ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
//  ПараметрыУказанияСерий - Произвольный - определен в модуле ИнтеграцияИС.ПараметрыУказанияСерий.
Процедура ПриИзмененииНоменклатуры(Форма,
								ТекущаяСтрока,
								КэшированныеЗначения,
								ПараметрыЗаполнения,
								ПараметрыУказанияСерий = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	ИмяТЧ = ПараметрыЗаполнения.ИмяТабличнойЧасти;
	
	ЗаполнитьПризнакАртикул                    = Новый Структура("Номенклатура", "Артикул");
	ЗаполнитьПризнакТипНоменклатуры            = Новый Структура("Номенклатура", "ТипНоменклатуры");
	НоменклатураПриИзмененииПереопределяемый   = Новый Структура("ИмяФормы, ИмяТабличнойЧасти", Форма.ИмяФормы, ИмяТЧ);
	ЗаполнитьПризнакХарактеристикиИспользуются = Новый Структура("Номенклатура", "ХарактеристикиИспользуются");
	ЗаполнитьПризнакЕдиницаИзмерения           = Новый Структура("Номенклатура", "ЕдиницаИзмерения");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПризнакАртикул",                    ЗаполнитьПризнакАртикул);
	СтруктураДействий.Вставить("ЗаполнитьПризнакТипНоменклатуры",            ЗаполнитьПризнакТипНоменклатуры);
	СтруктураДействий.Вставить("НоменклатураПриИзмененииПереопределяемый",   НоменклатураПриИзмененииПереопределяемый);
	СтруктураДействий.Вставить("ПроверитьХарактеристикуПоВладельцу",         ТекущаяСтрока.Характеристика);
	СтруктураДействий.Вставить("ЗаполнитьПризнакХарактеристикиИспользуются", ЗаполнитьПризнакХарактеристикиИспользуются);
	СтруктураДействий.Вставить("ЗаполнитьПризнакЕдиницаИзмерения",           ЗаполнитьПризнакЕдиницаИзмерения);
	СтруктураДействий.Вставить("ЗаполнитьПродукциюВЕТИС",                    ПараметрыЗаполнения);
	
	Если ПараметрыЗаполнения.ЗаполнитьПризнакСкоропортящаясяПродукция Тогда
		ЗаполнитьПризнакСкоропортящаясяПродукция = Новый Структура("Номенклатура", "СкоропортящаясяПродукция");
		СтруктураДействий.Вставить("ЗаполнитьПризнакСкоропортящаясяПродукция", ЗаполнитьПризнакСкоропортящаясяПродукция);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницВЕТИС Тогда
		ПересчитатьКоличествоЕдиницВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницВЕТИС", ПересчитатьКоличествоЕдиницВЕТИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС Тогда
		ПересчитатьКоличествоЕдиницПоВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницПоВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницПоВЕТИС", ПересчитатьКоличествоЕдиницПоВЕТИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус Тогда
		
		Если ПараметрыУказанияСерий <> Неопределено
			И ЗначениеЗаполнено(ПараметрыУказанияСерий.ИмяПоляСклад)
			И ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта], ПараметрыУказанияСерий.ИмяПоляСклад) Тогда
			
			Склад = Форма[ПараметрыУказанияСерий.ИмяИсточникаЗначенийВФормеОбъекта][ПараметрыУказанияСерий.ИмяПоляСклад];
			
		Иначе
			Склад = Неопределено;
		КонецЕсли;
		
		ПроверитьСериюРассчитатьСтатус = Новый Структура("ПараметрыУказанияСерий, Склад", ПараметрыУказанияСерий, Склад);
		
		СтруктураДействий.Вставить("ПроверитьСериюРассчитатьСтатус", ПроверитьСериюРассчитатьСтатус);
		
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении характеристики в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке,
//  ПараметрыЗаполнения  - Структура                   - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииХарактеристики(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	ИмяТЧ = ПараметрыЗаполнения.ИмяТабличнойЧасти;
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ЗаполнитьПродукциюВЕТИС", ПараметрыЗаполнения);
	
	СтруктураДействий.Вставить("ХарактеристикаПриИзмененииПереопределяемый", Новый Структура("ИмяФормы, ИмяТабличнойЧасти",
		Форма.ИмяФормы, ИмяТЧ));
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при создании характеристики в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  Элемент              - ПолеФормы                   - поле, в котором происходит создание характеристики,
//  СтандартнаяОбработка - Булево                      - признак отказа от стандартной обработки события.
Процедура ХарактеристикаСоздание(Форма, ТекущаяСтрока, Элемент, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении серии в таблице Товары.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ПараметрыУказанияСерий - Структура        - состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий,
//  ТекущиеДанные          - ДанныеФормыЭлементКоллекции, Структура - строка таблицы товаров,
//  КэшированныеЗначения   - Структура        - сохраненные значения параметров, используемых при обработке строки таблицы,
//  ПараметрыЗаполнения    - Структура        - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииСерии(Форма,
							ПараметрыУказанияСерий,
							ТекущиеДанные,
							КэшированныеЗначения = Неопределено,
							ПараметрыЗаполнения = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранноеЗначение = НоменклатураКлиентСервер.ВыбраннаяСерия();
	ВыбранноеЗначение.Значение = ТекущиеДанные.Серия;
	
	Если ТипЗнч(ТекущиеДанные) = Тип("ДанныеФормыЭлементКоллекции") Тогда
		ВыбранноеЗначение.ИдентификаторТекущейСтроки = ТекущиеДанные.ПолучитьИдентификатор();
	КонецЕсли;
	
	НоменклатураКлиент.ОбработатьУказаниеСерии(Форма, ПараметрыУказанияСерий, ВыбранноеЗначение);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении единицы измерения ВЕТИС в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке строки таблицы,
//  ПараметрыЗаполнения  - Структура                   - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииЕдиницыИзмеренияВЕТИС(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницВЕТИС Тогда
		ПересчитатьКоличествоЕдиницВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницВЕТИС", ПересчитатьКоличествоЕдиницВЕТИС);
	КонецЕсли;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС Тогда
		ПересчитатьКоличествоЕдиницПоВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницПоВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницПоВЕТИС", ПересчитатьКоличествоЕдиницПоВЕТИС);
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении количества ВЕТИС в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке строки таблицы,
//  ПараметрыЗаполнения  - Структура                   - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииКоличестваВЕТИС(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС Тогда
		ПересчитатьКоличествоЕдиницПоВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницПоВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницПоВЕТИС", ПересчитатьКоличествоЕдиницПоВЕТИС);
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при изменении количества в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  КэшированныеЗначения - Структура                   - сохраненные значения параметров, используемых при обработке строки таблицы,
//  ПараметрыЗаполнения  - Структура                   - см. функцию ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти.
Процедура ПриИзмененииКоличества(Форма, ТекущаяСтрока, КэшированныеЗначения, ПараметрыЗаполнения) Экспорт
	
	//++ НЕ ГОСИС
	СтруктураДействий = Новый Структура;
	
	Если ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницВЕТИС Тогда
		ПересчитатьКоличествоЕдиницВЕТИС = Новый Структура("ЕдиницаИзмеренияВЕТИС, Суффикс");
		ЗаполнитьЗначенияСвойств(ПересчитатьКоличествоЕдиницВЕТИС, ПараметрыЗаполнения);
		
		СтруктураДействий.Вставить("ПересчитатьКоличествоЕдиницВЕТИС", ПересчитатьКоличествоЕдиницВЕТИС);
	КонецЕсли;
	
	ОбработкаТабличнойЧастиКлиент.ОбработатьСтрокуТЧ(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Выполняет действия при начале выбора характеристики в таблице Товары.
//
// Параметры:
//  Форма                - ФормаКлиентскогоПриложения            - форма, в которой произошло событие,
//  ТекущаяСтрока        - ДанныеФормыЭлементКоллекции - строка таблицы товаров,
//  Элемент              - ПолеВвода                   - элемент формы Характеристика,
//  ДанныеВыбора         - СписокЗначений              - в обработчике можно сформировать и передать в этом параметре данные для выбора,
//  СтандартнаяОбработка - Булево                      - признак выполнения стандартной (системной) обработки события.
Процедура НачалоВыбораХарактеристики(Форма, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка) Экспорт
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки выбора номенклатуры, если произошел выбор из формы выбора.
//
// Параметры:
//  ОповещениеПриЗавершении - ОписаниеОповещения - процедура завершения выбора номенклатуры,
//  ВыбранноеЗначение       - Произвольный       - результат выбора,
//  ИсточникВыбора          - ФормаКлиентскогоПриложения   - форма, в которой осуществлен выбор номенклатуры.
Процедура ОбработкаВыбораНоменклатуры(ОповещениеПриЗавершении, ВыбранноеЗначение, ИсточникВыбора) Экспорт
	
	//++ НЕ ГОСИС
	Если ТипЗнч(ОповещениеПриЗавершении.Модуль) = Тип("ФормаКлиентскогоПриложения") Тогда
		ОповещениеПриЗавершении.Модуль.Модифицированность = Истина;
	КонецЕсли;
	Если СтрНачинаетсяС(ИсточникВыбора.ИмяФормы, "Справочник.Номенклатура") Тогда
		ВыполнитьОбработкуОповещения(ОповещениеПриЗавершении, ВыбранноеЗначение);
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки получения данных выбора номенклатуры, если произошло окончание ввода текста.
//
// Параметры:
//  ДанныеВыбора             - СписокЗначений - данные выбора номенклатуры, параметр события "ОкончаниеВводаТекста" поля формы,
//  ПараметрыПолученияДанных - Структура      - структура получения данных номенклатуры, параметр события "ОкончаниеВводаТекста" поля формы,
//  СтандартнаяОбработка     - Булево         - признак стандартной обработки выбора номенклатуры, параметр события "ОкончаниеВводаТекста" поля формы.
Процедура ОбработкаПолученияДанныхВыбораНоменклатуры(ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка) Экспорт
	
	//++ НЕ ГОСИС
	Если ПараметрыПолученияДанных.Отбор = Неопределено Тогда
		ПараметрыПолученияДанных.Отбор = Новый Структура;
	КонецЕсли;
	
	ОсобенностьУчета = Новый Массив;
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПодконтрольнаяПродукцияВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МолочнаяПродукцияПодконтрольнаяВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ЗерноВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.ПродуктыПереработкиЗернаВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МорепродуктыПодконтрольныеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КормаДляЖивотныхПодконтрольныеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.МясоПодконтрольноеВЕТИС"));
	ОсобенностьУчета.Добавить(ПредопределенноеЗначение("Перечисление.ОсобенностиУчетаНоменклатуры.КонсервированнаяПродукцияПодконтрольнаяВЕТИС"));
	
	ПараметрыПолученияДанных.ВыборГруппИЭлементов = ИспользованиеГруппИЭлементов.Элементы;
	ПараметрыПолученияДанных.Отбор.Вставить("ТипНоменклатуры", ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар"));
	ПараметрыПолученияДанных.Отбор.Вставить("ОсобенностьУчета", ОсобенностьУчета);
	НоменклатураВызовСервера.НоменклатураОбработкаПолученияДанныхВыбора(ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка);
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

// Вызывает процедуру обработки выбора серии, если произошел выбор из формы подбора.
//
// Параметры:
//  Форма                  - ФормаКлиентскогоПриложения - форма, в которой произошло событие,
//  ПараметрыУказанияСерий - Структура        - состав полей определен в функции НоменклатураКлиентСервер.ПараметрыУказанияСерий,
//  ВыбраннаяСерия         - ОпределяемыйТип.СерияНоменклатурыВЕТИС - обрабатываемое значение серии,
//  ИсточникВыбора         - ФормаКлиентскогоПриложения - форма, в которой осуществлен выбор,
//  ПараметрыЗаполнения    - Структура        - параметры обработки выбора серии.
Процедура ОбработкаВыбораСерии(Форма,
								ПараметрыУказанияСерий,
								ВыбраннаяСерия,
								ИсточникВыбора,
								ПараметрыЗаполнения = Неопределено) Экспорт
	
	//++ НЕ ГОСИС
	Если НоменклатураКлиент.ЭтоУказаниеСерий(ИсточникВыбора) Тогда
		НоменклатураКлиент.ОбработатьУказаниеСерии(Форма, ПараметрыУказанияСерий, ВыбраннаяСерия);
		
		Если ПараметрыЗаполнения <> Неопределено
			И ПараметрыЗаполнения.Свойство("ОписаниеОповещения") Тогда
			
			ВыполнитьОбработкуОповещения(ПараметрыЗаполнения.ОписаниеОповещения, ВыбраннаяСерия.Значение);
		КонецЕсли;
	КонецЕсли;
	//-- НЕ ГОСИС
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
