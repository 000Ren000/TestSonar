﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ДатаНачалаРасчета 			= НачалоМесяца(Параметры.ДатаНачалаРасчета);
	ПериодРегистрации 			= НачалоМесяца(Параметры.ПериодРегистрации);
	РасшифровкаЗапретаИзменений = Параметры.РасшифровкаЗапретаИзменений; // ХранилищеЗначения
	РасшифровкаЗапретаИзменений = РасшифровкаЗапретаИзменений.Получить();
	РасшифровкаБлокировки 		= Параметры.РасшифровкаБлокировки; // ХранилищеЗначения
	РасшифровкаБлокировки 		= РасшифровкаБлокировки.Получить();
	РасшифровкаЗаданий			= Параметры.РасшифровкаЗаданий; // ХранилищеЗначения
	
	Если НЕ ЗначениеЗаполнено(ДатаНачалаРасчета) ИЛИ НЕ ЗначениеЗаполнено(ПериодРегистрации)
	 ИЛИ НЕ ТипЗнч(РасшифровкаЗапретаИзменений) = Тип("ТаблицаЗначений")
	 ИЛИ НЕ ТипЗнч(РасшифровкаБлокировки) = Тип("ТаблицаЗначений") Тогда
		ВызватьИсключение НСтр("ru='Некорректный контекст открытия формы'");
	КонецЕсли;
	
	ЕстьДатыЗапрета     			  = Ложь;
	ЕстьОшибкиБлокировки  			  = Параметры.ПериодЗаблокированЧастично;
	ЕстьУчетныеПолитики 			  = Истина;
	ЕстьОрганизацииБезУчетнойПолитики = Ложь;
	
	// Заполним таблицу запретов из переданного параметра
	Для Каждого ТекСтр Из РасшифровкаЗапретаИзменений Цикл
		
		Если НЕ ЗначениеЗаполнено(ТекСтр.УчетнаяПолитика) Тогда
			ЕстьОрганизацииБезУчетнойПолитики = Истина;
		Иначе
			НачалоВеденияУчета = Макс(НачалоВеденияУчета, ТекСтр.УчетнаяПолитика);
		КонецЕсли;
		
		НоваяСтрока = ЗапретыИзменения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтр);
		
		НоваяСтрока.ПервыйРазрешенныйПериод = Макс(ТекСтр.РегламентныеОперации, ТекСтр.БухгалтерскийУчет, ТекСтр.МеждународныйУчет);
		
		ЕстьДатыЗапрета   = ЕстьДатыЗапрета
			ИЛИ (НоваяСтрока.ПервыйРазрешенныйПериод > ДатаНачалаРасчета);
		ЕстьУчетныеПолитики = ЕстьУчетныеПолитики И НЕ ЕстьОрганизацииБезУчетнойПолитики
			И (НоваяСтрока.УчетнаяПолитика <= ДатаНачалаРасчета ИЛИ НЕ НоваяСтрока.ЕстьДвижения);
			
		НоваяСтрока.ТребуетсяПересчетС = ДатаНачалаРасчета;
		
	КонецЦикла;

	// Заполним таблицу запретов из переданного параметра
	Для Каждого ТекСтр Из РасшифровкаБлокировки Цикл
		
		СтрокаТаблицы = ЗапретыИзменения.НайтиСтроки(Новый Структура("Организация", ТекСтр.Организация));
		Если СтрокаТаблицы.Количество() <> 1 Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаТаблицы = СтрокаТаблицы[0];
		
		Если ЗначениеЗаполнено(ТекСтр.ПериодБлокировки) Тогда
			СтрокаТаблицы.ПервыйНезаблокированныйПериод = КонецМесяца(ТекСтр.ПериодБлокировки) + 1;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекСтр.ПериодЗаданий) И ЗначениеЗаполнено(ТекСтр.ПериодБлокировки) И ТекСтр.ПериодЗаданий <= ТекСтр.ПериодБлокировки Тогда
			ЕстьОшибкиБлокировки = Истина; // некорректный период блокировки, есть задания
			СтрокаТаблицы.ОшибкаБлокировки = Истина;
			СтрокаТаблицы.ПервыйНезаблокированныйПериод = Дата(1,1,1);
		ИначеЕсли НачалоМесяца(ДатаНачалаРасчета) <= ТекСтр.ПериодБлокировки Тогда
			СтрокаТаблицы.ОшибкаБлокировки = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	// Настроим видимость элементов в зависимости от диагностированных проблем.
	Элементы.ЗапретыИзмененияПервыйРазрешенныйПериод.Видимость 		 = ЕстьДатыЗапрета;
	Элементы.ЗапретыИзмененияПервыйНезаблокированныйПериод.Видимость = ЕстьОшибкиБлокировки ИЛИ Параметры.ПериодЗаблокирован;
	Элементы.ФормаНастройкаБлокировкиОтИзменений.Видимость 			 = (ЕстьОшибкиБлокировки ИЛИ Параметры.ПериодЗаблокирован) И ЗакрытиеМесяцаСервер.ЕстьПравоУправленияБлокировкойПериода();
	Элементы.ЗапретыИзмененияУчетнаяПолитика.Видимость 		   		 = НЕ ЕстьУчетныеПолитики;

	ЭлементНастройкаДатЗапрета = Элементы.Найти("ФормаДатыЗапретаИзмененияДанных");
	Если ЭлементНастройкаДатЗапрета <> Неопределено Тогда
		ЭлементНастройкаДатЗапрета.Видимость = ЕстьДатыЗапрета;
	КонецЕсли;
	
	Если ПериодРегистрации > ДатаНачалаРасчета Тогда
		Элементы.ЗапретыИзмененияТребуетсяПересчетС.Заголовок = НСтр("ru='Требуется пересчет с'");
	Иначе
		Элементы.ЗапретыИзмененияТребуетсяПересчетС.Заголовок = НСтр("ru='Требуется пересчет за'");
	КонецЕсли;
	
	// Установим заголовок формы.
	ПредставлениеПериода =
		РасчетСебестоимостиПротоколРасчета.ПредставлениеПериодаРасчета(ДатаНачалаРасчета)
		+ ?(ПериодРегистрации > ДатаНачалаРасчета,
				" - " + РасчетСебестоимостиПротоколРасчета.ПредставлениеПериодаРасчета(ПериодРегистрации),
				"");
	
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru='Расчет за период %1 невозможен'", ОбщегоНазначения.КодОсновногоЯзыка()),
		ПредставлениеПериода);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьФорму(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаБлокировкиОтИзменений(Команда)
	
	ОбработчикЗакрытия = Новый ОписаниеОповещения("ЗакрытиеФормыНастройкиБлокировок", ЭтотОбъект);
	
	ОткрытьФорму(
		"РегистрСведений.НастройкаБлокировкиОтИзменений.Форма.ФормаНастройки",
		,
		ЭтотОбъект,
		УникальныйИдентификатор,
		,
		,
		ОбработчикЗакрытия,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ПосмотретьПериодыЗаданий(Команда)

	ТабДок = ТабличныйДокументЗаданий();
	ТабДок.Показать(НСтр("ru='Периоды заданий к расчету операций закрытия месяца'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗапретыИзменения

&НаКлиенте
Процедура ЗапретыИзмененияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ЗапретыИзменения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьЗначение(, ТекущиеДанные.Организация);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Запрет не задан.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияПервыйРазрешенныйПериод.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ПервыйРазрешенныйПериод");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Без запрета'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	
	// Период запрещен для изменения.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияПервыйРазрешенныйПериод.Имя);
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияОрганизация.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ПервыйРазрешенныйПериод");
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДатаНачалаРасчета");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
	// Блокировка не установлена.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияПервыйНезаблокированныйПериод.Имя);
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ПервыйНезаблокированныйПериод");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ОшибкаБлокировки");
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Не заблокированы'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	
	// Блокировка некорректна.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияПервыйНезаблокированныйПериод.Имя);
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ПервыйНезаблокированныйПериод");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ОшибкаБлокировки");
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Заблокированы некорректно'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
	// Блокировка части организаций.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияПервыйНезаблокированныйПериод.Имя);
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ПервыйНезаблокированныйПериод");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ОшибкаБлокировки");
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
	// Блокировка корректна.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияПервыйНезаблокированныйПериод.Имя);
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ПервыйНезаблокированныйПериод");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;

	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ОшибкаБлокировки");
	ОтборЭлемента.ПравоеЗначение = Ложь;
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	
	// Не задана учетная политика.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияУчетнаяПолитика.Имя);
	
	ОтборЭлемента = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Не указано'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
	// Нет учетных политик в рассчитываемом периоде.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияУчетнаяПолитика.Имя);
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияОрганизация.Имя);
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ГруппаОтбора2 = ГруппаОтбора.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора2.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДатаНачалаРасчета");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
	
	ОтборЭлемента = ГруппаОтбора2.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.ЕстьДвижения");
	ОтборЭлемента.ПравоеЗначение = Истина;
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);
	
	// Есть учетные политики в рассчитываемом периоде.
	ЭлементОформления = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = ЭлементОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ЗапретыИзмененияУчетнаяПолитика.Имя);
	
	ГруппаОтбора = ЭлементОформления.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Новый ПолеКомпоновкиДанных("ДатаНачалаРасчета");
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно;
	
	ОтборЭлемента = ГруппаОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("ЗапретыИзменения.УчетнаяПолитика");
	ОтборЭлемента.ПравоеЗначение = Дата(1,1,1);
	ОтборЭлемента.ВидСравнения   = ВидСравненияКомпоновкиДанных.НеРавно;
	
	ЭлементОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Зеленый);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеФормыНастройкиБлокировок(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	ПринудительноОбновитьФорму = ТипЗнч(РезультатЗакрытия) = Тип("Структура") И РезультатЗакрытия.Свойство("ОбновитьФормуЗакрытиМесяца");
	
	Если НЕ ПринудительноОбновитьФорму Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТабличныйДокументЗаданий()
	
	РасшифровкаЗаданий = РасшифровкаЗаданий; // ХранилищеЗначения
	
	Возврат РасчетСебестоимостиУниверсальныеАлгоритмы.ТаблицуЗначенийВТабличныйДокумент(РасшифровкаЗаданий.Получить());
	
КонецФункции

#КонецОбласти
