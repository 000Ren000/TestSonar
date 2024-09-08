﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СтруктураЗаполнения") Тогда
		
		СтруктураЗаполнения = Параметры.СтруктураЗаполнения;
		
		РаспоряжениеНаПоступление = СтруктураЗаполнения.Распоряжение;
		СоздатьПриходныйОрдер(СтруктураЗаполнения);
		
	Иначе
		
		Ссылка = Параметры.Ссылка;
		РаспоряжениеНаПоступление = Параметры.Ссылка.Распоряжение
		
	КонецЕсли;
	
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;

	ЗаполнитьФорму();
	
	//++ Локализация
	
	ИспользоватьУчетМаркируемойПродукции = Константы.ВестиУчетМаркируемойПродукцииИСМП.Получить();
	ПроверкаИПодборПродукцииИСМППереопределяемый.ПриОпределенииОрганизации(Ссылка, Организация);
	
	ЕстьМаркируемаяПродукция = Ложь;
	ВидыПродукцииИСМП = МобильноеРабочееМестоКладовщикаЛокализация.ВидыПродукцииИСМП();
	ПроверкаИПодборПродукцииИСМППереопределяемый.ЕстьМаркируемаяПродукцияВКоллекции(ТоварыКПоступлению, ВидыПродукцииИСМП, ЕстьМаркируемаяПродукция);
	Если НЕ ЕстьМаркируемаяПродукция Тогда
		ПроверкаИПодборПродукцииИСМППереопределяемый.ЕстьМаркируемаяПродукцияВКоллекции(ТоварыПринято, ВидыПродукцииИСМП, ЕстьМаркируемаяПродукция);
	КонецЕсли;
	
	//-- Локализация
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОформитьМеню("КПоступлению");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			
			// Преобразуем предварительно к ожидаемому формату
			Если Параметр[1] = Неопределено Тогда
				Штрихкод = Параметр[0];
			Иначе
				Штрихкод = Параметр[1][1];
			КонецЕсли;
			
			ПараметрыКарточкаТовара = НайтиТоварСервер(Штрихкод);
			
			Если НЕ ЗначениеЗаполнено(ПараметрыКарточкаТовара.Номенклатура) Тогда
				
				ТекстОшибки = СтрШаблон(НСтр("ru='Не найдена номенклатура со штрихкодом: %1'"), Штрихкод);
				ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
				
				Возврат;
			КонецЕсли;
			
			Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
			
			ПараметрыФормы = Новый Структура;
			ПараметрыФормы.Вставить("Номенклатура", ПараметрыКарточкаТовара.Номенклатура);
			ПараметрыФормы.Вставить("Характеристика", ПараметрыКарточкаТовара.Характеристика);
			ПараметрыФормы.Вставить("Упаковка", ПараметрыКарточкаТовара.Упаковка);
			ПараметрыФормы.Вставить("Количество", ПараметрыКарточкаТовара.Количество);
			ПараметрыФормы.Вставить("Режим", "Приемка");
			ПараметрыФормы.Вставить("НомерСтроки", 0);
			ПараметрыФормы.Вставить("Склад", Склад);
			ПараметрыФормы.Вставить("Помещение", Помещение);
			ПараметрыФормы.Вставить("ЭтоСканирование", Истина);
			ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);

			ОткрытьФорму(
			"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
			ЭтаФорма,,,,Описание,
			РежимОткрытияОкнаФормы.Независимый);
			
		КонецЕсли;
		
	КонецЕсли;
	
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПерейтиВРазделКПриемке(Команда)
	ОформитьМеню("КПоступлению");
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВРазделПринято(Команда)
	ОформитьМеню("Принято");
КонецПроцедуры

&НаКлиенте
Процедура ТоварыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Элемент.ТекущиеДанные.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Элемент.ТекущиеДанные.Характеристика);
	ПараметрыФормы.Вставить("Серия", Элемент.ТекущиеДанные.Серия);
	ПараметрыФормы.Вставить("Назначение", Элемент.ТекущиеДанные.Назначение);
	ПараметрыФормы.Вставить("Упаковка", Элемент.ТекущиеДанные.Упаковка);
	ПараметрыФормы.Вставить("Количество", Элемент.ТекущиеДанные.КоличествоУпаковок);
	ПараметрыФормы.Вставить("Режим", "Приемка");
	ПараметрыФормы.Вставить("НомерСтроки", Элемент.ТекущаяСтрока);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);

	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПринятоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Элемент.ТекущиеДанные.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Элемент.ТекущиеДанные.Характеристика);
	ПараметрыФормы.Вставить("Серия", Элемент.ТекущиеДанные.Серия);
	ПараметрыФормы.Вставить("Назначение", Элемент.ТекущиеДанные.Назначение);
	ПараметрыФормы.Вставить("Упаковка", Элемент.ТекущиеДанные.Упаковка);
	ПараметрыФормы.Вставить("Количество", Элемент.ТекущиеДанные.КоличествоУпаковок);
	ПараметрыФормы.Вставить("Режим", "РедактированиеПриемка");
	ПараметрыФормы.Вставить("НомерСтроки", ТоварыПринято.Индекс(Элементы.ТоварыПринято.ТекущиеДанные));
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);

	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);

КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьПриемку(Команда)
	
	СписокЗначений = Новый СписокЗначений;
	СписокЗначений.Добавить("Завершить", НСтр("ru = 'Завершить'"));
	СписокЗначений.Добавить("Продолжить", НСтр("ru = 'Продолжить'"));
	
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопроса", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Завершить приемку?'"), СписокЗначений, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура ПомещениеПриИзменении(Элемент)
	ЗаполнитьЗонуПриемки();
КонецПроцедуры

&НаКлиенте
Процедура СобратьВсе(Команда)
	Оповещение = Новый ОписаниеОповещения("ПослеЗакрытияВопросаСобратьВсе", ЭтотОбъект);
	ПоказатьВопрос(Оповещение, НСтр("ru = 'Вкладка Принято будет очищена, продолжить?'"),РежимДиалогаВопрос.ДаНет,0);
КонецПроцедуры

&НаКлиенте
Процедура Сканировать(Команда)
	
	СтандартнаяОбработка = Ложь;
	
	Описание = Новый ОписаниеОповещения("РезультатСканирования", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТипПоиска", "ПоискНоменклатуры");
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	ПараметрыФормы.Вставить("ДокументСсылка", Ссылка);
	ПараметрыФормы.Вставить("ШтрихкодыУпаковок", ШтрихкодыУпаковок);
	ПараметрыФормы.Вставить("Организация", Организация);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СканированиеШтрихкода",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПриемку(Команда)
	
	ИндексСтроки = ТоварыПринято.Индекс(Элементы.ТоварыПринято.ТекущиеДанные);
	Если ИндексСтроки >= 0 Тогда
		ТоварыПринято.Удалить(ИндексСтроки);
	КонецЕсли;
	
	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаКлиенте
Процедура КодыМаркировки(Команда)
	Описание = Новый ОписаниеОповещения("ИзменитьШтрихкодыУпаковок", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ШтрихкодыУпаковок", ШтрихкодыУпаковок);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.СписокКодовМаркировки",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Элементы.Помещение.Видимость      = ИспользоватьПомещения;
	Элементы.ЗонаПриемки.Видимость    = ИспользоватьАдресноеХранение;
	Элементы.КодыМаркировки.Видимость = ИспользоватьУчетМаркируемойПродукции И ЕстьМаркируемаяПродукция;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатСканирования(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Описание = Новый ОписаниеОповещения("ОбновитьФорму", ЭтаФорма);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Результат.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Результат.Характеристика);
	Если Результат.Свойство("Серия") Тогда
		ПараметрыФормы.Вставить("Серия", Результат.Серия);
	Иначе
		ПараметрыФормы.Вставить("Серия", ПустаяСерия);
	КонецЕсли;
	ПараметрыФормы.Вставить("Упаковка", Результат.Упаковка);
	Если Результат.Свойство("Количество") Тогда
		ПараметрыФормы.Вставить("Количество", Результат.Количество);
	Иначе
		ПараметрыФормы.Вставить("Количество", 1);
	КонецЕсли;
	ПараметрыФормы.Вставить("Режим", "Приемка");
	ПараметрыФормы.Вставить("НомерСтроки", 0);
	ПараметрыФормы.Вставить("Склад", Склад);
	ПараметрыФормы.Вставить("Помещение", Помещение);
	Если Результат.Свойство("ШтрихкодУпаковки") Тогда
		ПараметрыФормы.Вставить("ШтрихкодУпаковки", Результат.ШтрихкодУпаковки);
	Иначе
		ПараметрыФормы.Вставить("ШтрихкодУпаковки", Неопределено);
	КонецЕсли;
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);

	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.КарточкаТовара",ПараметрыФормы,
	ЭтаФорма,,,,Описание,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьПриходныйОрдер(СтруктураЗаполнения)
	
	НовыйОрдер = Документы.ПриходныйОрдерНаТовары.СоздатьДокумент();
	
	НовыйОрдер.Заполнить(СтруктураЗаполнения);
	НовыйОрдер.Дата = ТекущаяДатаСеанса();
	НовыйОрдер.Исполнитель = Пользователи.ТекущийПользователь();
	
	ПараметрыУказанияСерий = Документы.ПриходныйОрдерНаТовары.ПараметрыУказанияСерий(НовыйОрдер);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(НовыйОрдер, ПараметрыУказанияСерий);
	
	Попытка
		НовыйОрдер.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		НовыйОрдер.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;
	
	Склад       = НовыйОрдер.Склад;
	Помещение   = НовыйОрдер.Помещение;
	Исполнитель = НовыйОрдер.Исполнитель;
	
	Ссылка = НовыйОрдер.Ссылка;
	
КонецПроцедуры 

&НаКлиенте
Процедура ОформитьМеню(ИмяВкладки)
	
	ПоказатьМеню();
	
	Элементы.РамкаКПоступлению.Картинка = БиблиотекаКартинок.РамкаМенюБелая;
	Элементы.КомандаКПоступлению.ЦветТекста = WebЦвета.ТемноСерый;
	
	Элементы.РамкаПринято.Картинка = БиблиотекаКартинок.РамкаМенюБелая;
	Элементы.КомандаПринято.ЦветТекста = WebЦвета.ТемноСерый;
		
	Если ИмяВкладки = "КПоступлению" Тогда
		Элементы.РамкаКПоступлению.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;
		Элементы.КомандаКПоступлению.ЦветТекста = WebЦвета.Черный;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаКПоступлению;
	ИначеЕсли ИмяВкладки = "Принято" Тогда
		Элементы.РамкаПринято.Картинка = БиблиотекаКартинок.РамкаМенюЧерная;	
		Элементы.КомандаПринято.ЦветТекста = WebЦвета.Черный;
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.СтраницаПринято;
	КонецЕсли;

	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьЗаголовкиКомандМеню()
	Элементы.КомандаКПоступлению.Заголовок = СтрШаблон(НСтр("ru = 'К приемке (%1)'"), ТоварыКПоступлению.Количество());
	Элементы.КомандаПринято.Заголовок = СтрШаблон(НСтр("ru = 'Принято (%1)'"), ТоварыПринято.Количество());
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФорму()
	
	СтруктураОрдера = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
		"Склад, Комментарий, Помещение, ЗонаПриемки, Исполнитель, НомерВходящегоДокумента, ДатаВходящегоДокумента, Товары");
	
	Склад       = СтруктураОрдера.Склад;
	Комментарий = СтруктураОрдера.Комментарий;
	Помещение   = СтруктураОрдера.Помещение;
	ЗонаПриемки = СтруктураОрдера.ЗонаПриемки;
	Исполнитель = СтруктураОрдера.Исполнитель;
	НомерВходящегоДокумента = СтруктураОрдера.НомерВходящегоДокумента;
	ДатаВходящегоДокумента  = СтруктураОрдера.ДатаВходящегоДокумента;
	
	СвойстваСклада = Обработки.МобильноеРабочееМестоКладовщика.СвойстваСклада(Склад);
	
	ИспользоватьАдресноеХранение            = СвойстваСклада.ИспользоватьАдресноеХранение;
	ИспользоватьОрдернуюСхемуПриПоступлении = СвойстваСклада.ИспользоватьОрдернуюСхемуПриПоступлении;
	
	Если СвойстваСклада.ИспользоватьСкладскиеПомещения Тогда
		СтруктураПомещения = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Помещение, "ИспользоватьАдресноеХранение");
		ИспользоватьАдресноеХранение = СтруктураПомещения.ИспользоватьАдресноеХранение;
	КонецЕсли;
	
	ТоварыКПоступлению.Загрузить(СтруктураОрдера.Товары.Выгрузить());
	
	Для Каждого Строка Из СтруктураОрдера.Товары.Выгрузить() Цикл
		
		Если Строка.Количество > 0 Тогда
			НоваяСтрока = ТоварыПринято.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "ШтрихкодыУпаковок");
	Для Каждого Строка Из СтруктураРеквизитов.ШтрихкодыУпаковок.Выгрузить() Цикл
		
		СтрокаШтрихкод = ШтрихкодыУпаковок.Добавить();
		СтрокаШтрихкод.ШтрихкодУпаковки = Строка.ШтрихкодУпаковки;
		
		СтруктураРеквизитовШтрихкода = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Строка.ШтрихкодУпаковки,
			"Номенклатура, Характеристика");
			
		СтрокаШтрихкод.Номенклатура = СтруктураРеквизитовШтрихкода.Номенклатура;
		СтрокаШтрихкод.Характеристика = СтруктураРеквизитовШтрихкода.Характеристика;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьФормуНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьФормуНаСервере(Результат)

	КоэффициентУпаковки = Справочники.УпаковкиЕдиницыИзмерения.КоэффициентУпаковки(Результат.Упаковка, Результат.Номенклатура);
	
	Если Результат.Режим = "РедактированиеПриемка" Тогда
		
		Литерал = "НомерСтроки";
		НомерСтроки = Результат[Литерал];
		
		ТоварыПринято[НомерСтроки].Упаковка           = Результат.Упаковка;
		ТоварыПринято[НомерСтроки].КоличествоУпаковок = Результат.КоличествоУпаковок;
		ТоварыПринято[НомерСтроки].Количество         = ТоварыПринято[НомерСтроки].КоличествоУпаковок * КоэффициентУпаковки;
		ТоварыПринято[НомерСтроки].Серия              = Результат.Серия;
		ТоварыПринято[НомерСтроки].Назначение         = Результат.Назначение;
		
	Иначе
		
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Номенклатура", Результат.Номенклатура);
		СтруктураПоиска.Вставить("Характеристика", Результат.Характеристика);
		СтруктураПоиска.Вставить("Серия", Результат.Серия);
		СтруктураПоиска.Вставить("Упаковка", Результат.Упаковка);
		СтруктураПоиска.Вставить("Назначение", Результат.Назначение);
		
		РезультатПоиска = ТоварыПринято.НайтиСтроки(СтруктураПоиска);
		Если РезультатПоиска.Количество() > 0 Тогда
			РезультатПоиска[0].КоличествоУпаковок = РезультатПоиска[0].КоличествоУпаковок + Результат.КоличествоУпаковок;
			РезультатПоиска[0].Количество = РезультатПоиска[0].КоличествоУпаковок * КоэффициентУпаковки;
		Иначе
			НоваяСтрока = ТоварыПринято.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Результат);
			НоваяСтрока.Количество = НоваяСтрока.КоличествоУпаковок * КоэффициентУпаковки;
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого СтрокаКодМаркировки Из Результат.ШтрихкодыУпаковок Цикл
		
		НоваяСтрока = ШтрихкодыУпаковок.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКодМаркировки);
		
	КонецЦикла;
	
	СформироватьЗаголовкиКомандМеню();
	
КонецПроцедуры

&НаСервере
Функция ЗакончитьПриемкуНаСервере()
	
	ОрдерОбъект = Ссылка.ПолучитьОбъект();
	
	ОрдерОбъект.Помещение               = Помещение;
	ОрдерОбъект.Комментарий             = Комментарий;
	ОрдерОбъект.ЗонаПриемки             = ЗонаПриемки;
	ОрдерОбъект.Исполнитель             = Исполнитель;
	ОрдерОбъект.НомерВходящегоДокумента = НомерВходящегоДокумента;
	ОрдерОбъект.ДатаВходящегоДокумента  = ДатаВходящегоДокумента;
	
	Если ИспользоватьПомещения И НЕ ЗначениеЗаполнено(Помещение) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не выбрано помещение'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаИнформация"];
		
		Возврат Ложь;
		
	КонецЕсли;
	
	Если ИспользоватьАдресноеХранение и НЕ ЗначениеЗаполнено(ЗонаПриемки) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не выбрана зона приемки'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаИнформация"];
		
		Возврат Ложь;
		
	КонецЕсли;
	
	// Не проводим документ если не указаны упаковки
	МассивСообщений = Новый Массив;
	Если ИспользоватьАдресноеХранение Тогда
		Для Каждого Строка Из ТоварыПринято Цикл
			
			Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.Упаковка, "Владелец") = Справочники.НаборыУпаковок.БазовыеЕдиницыИзмерения 
				И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.Упаковка, "ТипИзмеряемойВеличины") = Перечисления.ТипыИзмеряемыхВеличин.КоличествоШтук Тогда
				
				ТекстСообщения = Строка(Строка.Номенклатура);
				
				Если ЗначениеЗаполнено(Строка.Характеристика) Тогда
					ТекстСообщения = ТекстСообщения + Символы.ПС + Строка(Строка.Характеристика);
				КонецЕсли;
				
				Если ЗначениеЗаполнено(Строка.Серия) Тогда
					ТекстСообщения = ТекстСообщения + Символы.ПС + Строка(Строка.Серия);
				КонецЕсли;
				
				МассивСообщений.Добавить(ТекстСообщения);
				
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
	Если МассивСообщений.Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru = 'Укажите упаковки для позиций:'");
		Для Каждого ЭлСообщения Из МассивСообщений Цикл
			ТекстСообщения = ТекстСообщения + Символы.ПС + ЭлСообщения;
		КонецЦикла;
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Возврат Ложь;
	КонецЕсли;
	
	Для Каждого Строка Из ТоварыПринято Цикл
		
		ВидНоменклатуры    = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Строка.Номенклатура, "ВидНоменклатуры");
		ПолитикаУчетаСерий = Обработки.МобильноеРабочееМестоКладовщика.ПолитикаУчетаСерий(ВидНоменклатуры, Склад);
		Если ЗначениеЗаполнено(ПолитикаУчетаСерий) Тогда
			ИспользоватьСерии = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПолитикаУчетаСерий, "УказыватьПриПриемке");
		Иначе
			ИспользоватьСерии = Ложь;
		КонецЕсли;
			
		Если НЕ ЗначениеЗаполнено(Строка.Серия) И (ЗначениеЗаполнено(ИспользоватьСерии) И ИспользоватьСерии) Тогда
			
			ТекстСообщения = Строка(Строка.Номенклатура);
			
			Если ЗначениеЗаполнено(Строка.Характеристика) Тогда
				ТекстСообщения = ТекстСообщения + Символы.ПС + Строка(Строка.Характеристика);
			КонецЕсли;
			
			МассивСообщений.Добавить(ТекстСообщения);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если МассивСообщений.Количество() > 0 Тогда
		ТекстСообщения = НСтр("ru = 'Укажите серии для позиций:'");
		Для Каждого ЭлСообщения Из МассивСообщений Цикл
			ТекстСообщения = ТекстСообщения + Символы.ПС + ЭлСообщения;
		КонецЦикла;
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		
		Возврат Ложь;
	КонецЕсли;
	
	Если ТоварыПринято.Количество() <> 0 Тогда
		ОрдерОбъект.Товары.Очистить();
		ОрдерОбъект.Статус = Перечисления.СтатусыПриходныхОрдеров.Принят;
	Иначе
		ОрдерОбъект.Статус = Перечисления.СтатусыПриходныхОрдеров.КПоступлению;
	КонецЕсли;
	
	Для Каждого Строка Из ТоварыПринято Цикл
		
		НоваяСтрока = ОрдерОбъект.Товары.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		
	КонецЦикла;
	
	ОрдерОбъект.ШтрихкодыУпаковок.Очистить();
	Для Каждого СтрокаШК Из ШтрихкодыУпаковок Цикл
		
		НоваяСтрока = ОрдерОбъект.ШтрихкодыУпаковок.Добавить();
		НоваяСтрока.ШтрихкодУпаковки = СтрокаШК.ШтрихкодУпаковки;
		
	КонецЦикла;
	
	ПараметрыУказанияСерий = Документы.ПриходныйОрдерНаТовары.ПараметрыУказанияСерий(ОрдерОбъект);
	НоменклатураСервер.ЗаполнитьСтатусыУказанияСерий(ОрдерОбъект, ПараметрыУказанияСерий);
	
	Попытка
		ОрдерОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ОрдерОбъект.Записать(РежимЗаписиДокумента.Запись);
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура Информация(Команда)
	
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаИнформация"];
	СкрытьМеню();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы["СтраницаИнформация"] Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		ОформитьМеню("Принято");
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьЗонуПриемки()
	
	ЗонаПриемки = Справочники.СкладскиеЯчейки.ЗонаПриемкиПоУмолчанию(Склад, Помещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьМеню()

	Элементы.ГруппаМеню.Видимость = Истина;
	Элементы.ГруппаКоманды.Видимость = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьМеню()

	Элементы.ГруппаМеню.Видимость = Ложь;
	Элементы.ГруппаКоманды.Видимость = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура СобратьВсеНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ ВТТовары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТоварыКПоступлениюОстатки.ДокументПоступления КАК ДокументПоступления,
		|	ТоварыКПоступлениюОстатки.Номенклатура КАК Номенклатура,
		|	ТоварыКПоступлениюОстатки.Характеристика КАК Характеристика,
		|	ТоварыКПоступлениюОстатки.Назначение КАК Назначение,
		|	МАКСИМУМ(ТоварыКПоступлениюОстатки.Серия) КАК Серия
		|ПОМЕСТИТЬ Серии
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению.Остатки(, ДокументПоступления = &ДокументПоступления) КАК ТоварыКПоступлениюОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ТоварыКПоступлениюОстатки.ДокументПоступления,
		|	ТоварыКПоступлениюОстатки.Назначение,
		|	ТоварыКПоступлениюОстатки.Номенклатура,
		|	ТоварыКПоступлениюОстатки.Характеристика
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТоварыКПоступлениюОстатки.ДокументПоступления КАК ДокументПоступления,
		|	ТоварыКПоступлениюОстатки.Номенклатура КАК Номенклатура,
		|	ТоварыКПоступлениюОстатки.Характеристика КАК Характеристика,
		|	ТоварыКПоступлениюОстатки.Назначение КАК Назначение,
		|	ТоварыКПоступлениюОстатки.Склад КАК Склад,
		|	ТоварыКПоступлениюОстатки.Отправитель КАК Отправитель,
		|	ТоварыКПоступлениюОстатки.ХозяйственнаяОперация КАК ХозяйственнаяОперация,
		|	ТоварыКПоступлениюОстатки.КОформлениюОрдеровОстаток КАК Количество,
		|	ТоварыКПоступлениюОстатки.КОформлениюОрдеровОстаток КАК КоличествоУпаковок,
		|	ТоварыКПоступлениюОстатки.Номенклатура.ЕдиницаИзмерения КАК Упаковка,
		|	Серии.Серия КАК Серия
		|ИЗ
		|	РегистрНакопления.ТоварыКПоступлению.Остатки(
		|			,
		|			ДокументПоступления = &ДокументПоступления
		|				И Номенклатура В
		|					(ВЫБРАТЬ
		|						ВТТовары.Номенклатура КАК Номенклатура
		|					ИЗ
		|						ВТТовары)) КАК ТоварыКПоступлениюОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Серии КАК Серии
		|		ПО ТоварыКПоступлениюОстатки.ДокументПоступления = Серии.ДокументПоступления
		|			И ТоварыКПоступлениюОстатки.Номенклатура = Серии.Номенклатура
		|			И ТоварыКПоступлениюОстатки.Характеристика = Серии.Характеристика
		|			И ТоварыКПоступлениюОстатки.Назначение = Серии.Назначение
		|ГДЕ
		|	ТоварыКПоступлениюОстатки.КОформлениюОрдеровОстаток > 0";
	
	Запрос.УстановитьПараметр("ДокументПоступления", РаспоряжениеНаПоступление);
	Запрос.УстановитьПараметр("Товары", ТоварыКПоступлению.Выгрузить());
	
	Остатки = Запрос.Выполнить().Выгрузить();
	
	Если ИспользоватьАдресноеХранение Тогда
		РазбитьПоУпаковкамСправочно(Остатки);
		ТоварыПринято.Загрузить(Остатки);
	Иначе
		ТоварыПринято.Загрузить(Остатки);
		НоменклатураСервер.РазбитьТоварыПоТоварнымМестам(ТоварыПринято);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатПоискаНоменклатуры(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Номенклатура", Результат.Номенклатура);
	ПараметрыФормы.Вставить("Характеристика", Результат.Характеристика);
	ПараметрыФормы.Вставить("Упаковка", Результат.Упаковка);
	ПараметрыФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
	
	ОткрытьФорму(
	"Обработка.МобильноеРабочееМестоКладовщика.Форма.ПоискПоТовару",ПараметрыФормы,
	ЭтаФорма,,,,,
	РежимОткрытияОкнаФормы.Независимый);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиТоварСервер(Штрихкод)
	
	Возврат Обработки.МобильноеРабочееМестоКладовщика.НайтиТоварПоШК(Штрихкод);
	
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопроса(Результат, Параметры) Экспорт
	
	Если Результат = "Завершить" Тогда
		
		ПриемкаЗавершена = ЗакончитьПриемкуНаСервере();
		
		Если ПриемкаЗавершена Тогда
			Закрыть();
		КонецЕсли;
		
	Иначе
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаСобратьВсе(Результат, Параметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		
		СобратьВсеНаСервере();
		ОформитьМеню("Принято");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьШтрихкодыУпаковок(Результат, Параметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьШтрихкодыУпаковокНаСервере(Результат);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьШтрихкодыУпаковокНаСервере(Результат) Экспорт
	
	ШтрихкодыУпаковок.Очистить();
	ШтрихкодыУпаковок.Загрузить(Результат.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура РазбитьПоУпаковкамСправочно(Товары)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Таблица.Номенклатура КАК Номенклатура,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.НомерСтроки КАК НомерСтроки,
	|	Таблица.Количество КАК Количество,
	|	Таблица.КоличествоУпаковок КАК КоличествоУпаковок,
	|	ВЫРАЗИТЬ(Таблица.Упаковка КАК Справочник.УпаковкиЕдиницыИзмерения) КАК Упаковка,
	|	Таблица.Назначение КАК Назначение,
	|	Таблица.Серия КАК Серия
	|ПОМЕСТИТЬ ТаблицаНоменклатурыДляЗапроса
	|ИЗ
	|	&Таблица КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Номенклатура КАК Номенклатура,
	|	МИНИМУМ(Таблица.НомерСтроки) КАК НомерСтроки,
	|	ВЫРАЗИТЬ(Таблица.Номенклатура КАК Справочник.Номенклатура).НаборУпаковок КАК НаборУпаковок,
	|	Таблица.Характеристика КАК Характеристика,
	|	Таблица.Назначение КАК Назначение,
	|	Таблица.Серия КАК Серия,
	|	СУММА(Таблица.Количество) КАК Количество
	|ПОМЕСТИТЬ ТаблицаНоменклатуры
	|ИЗ
	|	ТаблицаНоменклатурыДляЗапроса КАК Таблица
	|ГДЕ
	|	ЕСТЬNULL(Таблица.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)
	|
	|СГРУППИРОВАТЬ ПО
	|	Таблица.Номенклатура,
	|	ВЫРАЗИТЬ(Таблица.Номенклатура КАК Справочник.Номенклатура).НаборУпаковок,
	|	Таблица.Характеристика,
	|	Таблица.Серия,
	|	Таблица.Назначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВнутреннийЗапрос.Номенклатура,
	|	ВнутреннийЗапрос.Количество,
	|	ВнутреннийЗапрос.ЭтоТоварноеМесто,
	|	ВнутреннийЗапрос.НомерСтроки,
	|	ВнутреннийЗапрос.Характеристика,
	|	ВнутреннийЗапрос.Назначение,
	|	ВнутреннийЗапрос.КоличествоВУпаковке,
	|	ВнутреннийЗапрос.Упаковка,
	|	ВнутреннийЗапрос.Серия,
	|	ВнутреннийЗапрос.ЕдиницаИзмеренияУпаковкиПредставление
	|ИЗ
	|	(ВЫБРАТЬ
	|		ТаблицаНоменклатуры.Номенклатура КАК Номенклатура,
	|		ТаблицаНоменклатуры.Количество КАК Количество,
	|		ЛОЖЬ КАК ЭтоТоварноеМесто,
	|		ТаблицаНоменклатуры.НомерСтроки КАК НомерСтроки,
	|		ТаблицаНоменклатуры.Характеристика КАК Характеристика,
	|		ТаблицаНоменклатуры.Назначение КАК Назначение,
	|		ТаблицаНоменклатуры.Серия КАК Серия,
	|		ЕСТЬNULL(&ТекстЗапросаКоэффициентУпаковки, 1) КАК КоличествоВУпаковке,
	|		ЕСТЬNULL(УпаковкиНоменклатуры.Ссылка, ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)) КАК Упаковка,
	|		ЕСТЬNULL(УпаковкиНоменклатуры.ЕдиницаИзмерения.Представление, """") КАК ЕдиницаИзмеренияУпаковкиПредставление
	|	ИЗ
	|		ТаблицаНоменклатуры КАК ТаблицаНоменклатуры
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.УпаковкиЕдиницыИзмерения КАК УпаковкиНоменклатуры
	|			ПО (ТаблицаНоменклатуры.Номенклатура = УпаковкиНоменклатуры.Владелец
	|					ИЛИ ТаблицаНоменклатуры.НаборУпаковок = УпаковкиНоменклатуры.Владелец)
	|				И (НЕ УпаковкиНоменклатуры.ПометкаУдаления)
	|				И (ТаблицаНоменклатуры.Количество >= &ТекстЗапросаКоэффициентУпаковки)
	|				И (&ТекстЗапросаКоэффициентУпаковки <> 0)
	|				И (ЕСТЬNULL(УпаковкиНоменклатуры.ТипУпаковки, НЕОПРЕДЕЛЕНО) <> ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто))
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТаблицаНоменклатуры.Номенклатура,
	|		ТаблицаНоменклатуры.Количество,
	|		ИСТИНА,
	|		ТаблицаНоменклатуры.НомерСтроки,
	|		ТаблицаНоменклатуры.Характеристика,
	|		ТаблицаНоменклатуры.Назначение,
	|		ТаблицаНоменклатуры.Упаковка.КоличествоУпаковок,
	|		ТаблицаНоменклатуры.Упаковка,
	|		ТаблицаНоменклатуры.Серия,
	|		""""
	|	ИЗ
	|		ТаблицаНоменклатурыДляЗапроса КАК ТаблицаНоменклатуры
	|	ГДЕ
	|		ЕСТЬNULL(ТаблицаНоменклатуры.Упаковка.ТипУпаковки, НЕОПРЕДЕЛЕНО) = ЗНАЧЕНИЕ(Перечисление.ТипыУпаковокНоменклатуры.ТоварноеМесто)) КАК ВнутреннийЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВнутреннийЗапрос.НомерСтроки,
	|	ВнутреннийЗапрос.КоличествоВУпаковке,
	|	ВнутреннийЗапрос.ЕдиницаИзмеренияУпаковкиПредставление";
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ТекстЗапросаКоэффициентУпаковки",
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаКоэффициентаУпаковки(
			"УпаковкиНоменклатуры",
			"ТаблицаНоменклатуры.Номенклатура"));
	
	ТаблицаНоменклатуры = Товары.Скопировать();
	ТаблицаНоменклатуры.Колонки.Добавить("НомерСтроки",    Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10,0)));
	
	НомерСтроки = 1;
	Для Каждого Строка Из ТаблицаНоменклатуры Цикл
		Строка.НомерСтроки = НомерСтроки;
		НомерСтроки = НомерСтроки + 1;
	КонецЦикла;
	
	Запрос.УстановитьПараметр("Таблица",ТаблицаНоменклатуры);
	
	Товары.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТекНомерСтроки = Неопределено;
	ТекНоменклатура = Неопределено;
	ТекХарактеристика = Неопределено;
	ТекНазначение = Неопределено;
	ТекСерия = Неопределено;
	Количество = Неопределено;
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.НомерСтроки <> ТекНомерСтроки Тогда
			
			Если Количество <> Неопределено Тогда
				НоваяСтрока = Товары.Добавить();
				НоваяСтрока.Количество = Количество;
				НоваяСтрока.КоличествоУпаковок = Количество;
				
				НоваяСтрока.Номенклатура = ТекНоменклатура;
				НоваяСтрока.Характеристика = ТекХарактеристика;
				НоваяСтрока.Назначение = ТекНазначение;
				НоваяСтрока.Серия = ТекСерия;
			КонецЕсли;
			
			ТекНомерСтроки              = Выборка.НомерСтроки;
			ТекНоменклатура             = Выборка.Номенклатура; 
			ТекХарактеристика           = Выборка.Характеристика;
			ТекНазначение               = Выборка.Назначение;
			ТекСерия                    = Выборка.Серия;
			
			Если Выборка.ЭтоТоварноеМесто Тогда
				
				НоваяСтрока = Товары.Добавить();
				НоваяСтрока.Количество = Выборка.Количество;
				НоваяСтрока.КоличествоУпаковок =  Выборка.Количество * Выборка.КоличествоВУпаковке;
				НоваяСтрока.Упаковка = Выборка.Упаковка;
				
				НоваяСтрока.Номенклатура = ТекНоменклатура;
				НоваяСтрока.Характеристика = ТекХарактеристика;
				НоваяСтрока.Назначение = ТекНазначение;
				НоваяСтрока.Серия = ТекСерия;
				
				Продолжить;
				
			КонецЕсли;
			
			Количество = Выборка.Количество;//(Не Выборка.ЭтоТоварноеМесто, Выборка.Количество, Выборка.КоличествоУпаковок);
			
		КонецЕсли;
		
		Если Количество <> Неопределено Тогда
			Если ЗначениеЗаполнено(Выборка.Упаковка) Тогда
				КоличествоВДокумент = Цел(Количество / Выборка.КоличествоВУпаковке);
			Иначе
				КоличествоВДокумент = Количество;
			КонецЕсли;
			
			Если КоличествоВДокумент > 0 Тогда
				
				НоваяСтрока = Товары.Добавить();
				НоваяСтрока.Количество = КоличествоВДокумент * Выборка.КоличествоВУпаковке;
				НоваяСтрока.КоличествоУпаковок = КоличествоВДокумент;
				НоваяСтрока.Упаковка = Выборка.Упаковка;
				
				НоваяСтрока.Номенклатура = ТекНоменклатура;
				НоваяСтрока.Характеристика = ТекХарактеристика;
				НоваяСтрока.Назначение = ТекНазначение;
				НоваяСтрока.Серия = ТекСерия;
				
				Если Количество = КоличествоВДокумент * Выборка.КоличествоВУпаковке Тогда
					Количество = Неопределено;
				Иначе
					Количество = Количество - КоличествоВДокумент * Выборка.КоличествоВУпаковке;
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Если Количество <> Неопределено Тогда
		НоваяСтрока = Товары.Добавить();
		НоваяСтрока.Количество = Количество;
		НоваяСтрока.КоличествоУпаковок = Количество;
		НоваяСтрока.Номенклатура = ТекНоменклатура;
		НоваяСтрока.Характеристика = ТекХарактеристика;
		НоваяСтрока.Назначение = ТекНазначение;
		НоваяСтрока.Серия = ТекСерия;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти