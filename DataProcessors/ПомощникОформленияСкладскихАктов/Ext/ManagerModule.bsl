﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получить список товаров к оформлению складских актов
//
// Параметры:
//  Склады				 - Массив							 - массив складов
//  ОтборНоменклатуры	 - КомпоновщикНастроекКомпоновкиДанных	 - настройки отбора номенклатуры
//  ДатаНачала			 - Дата									 - дата начала инвентаризации
//  ДатаОкончания		 - Дата									 - дата окончания инвентаризации.
// 
// Возвращаемое значение:
//  ТаблицаЗначений - таблица номенклатуры.
//
Функция ТоварыКОформлениюСкладскихАктов(Знач Склады, 
														Знач ОтборНоменклатуры = Неопределено, 
														Знач ДатаНачала = Неопределено, 
														Знач ДатаОкончания = Неопределено) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	СхемаКомпоновкиДанных = ПолучитьМакет("ОтборНоменклатурыОсновнойУТКА");
	
	Если ОтборНоменклатуры = Неопределено Тогда
		ОтборНоменклатуры = Новый КомпоновщикНастроекКомпоновкиДанных;
		URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
		ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);
		ОтборНоменклатуры.Инициализировать(ИсточникНастроек);
		ОтборНоменклатуры.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	УстановитьЗначениеПараметраНастроек(ОтборНоменклатуры.Настройки, "Склад", Склады);
	
	ДатыУказаны = Истина;
	Если ДатаНачала = Неопределено И ДатаОкончания = Неопределено Тогда
		ДатыУказаны = Ложь;	
	КонецЕсли;
	
	Если ДатаНачала = Неопределено Тогда
		ДатаНачала = Дата(1,1,1);
	КонецЕсли;
	
	Период = Дата(1,1,1);
	Если ДатаОкончания = Неопределено Тогда
		ДатаОкончания = Дата(1,1,1);
	Иначе
		Период = Новый Граница(КонецДня(ДатаОкончания));
	КонецЕсли;
	
	Если ДатаОкончания < ДатаНачала Тогда
		ВызватьИсключение НСтр("ru = 'Параметр ""Дата окончания"" меньше параметра ""Даты начала"".'");
	КонецЕсли;
			
	УстановитьЗначениеПараметраНастроек(ОтборНоменклатуры.Настройки, "ДатаНачала", 		ДатаНачала);
	УстановитьЗначениеПараметраНастроек(ОтборНоменклатуры.Настройки, "ДатаОкончания", 	ДатаОкончания);
	УстановитьЗначениеПараметраНастроек(ОтборНоменклатуры.Настройки, "Период", 			Период);
	УстановитьЗначениеПараметраНастроек(ОтборНоменклатуры.Настройки, "ДатыУказаны", 	ДатыУказаны);
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(ОтборНоменклатуры);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, ОтборНоменклатуры.ПолучитьНастройки(), , ,
		Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,,, Истина);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	ТаблицаНоменклатуры = ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
	УстановитьПривилегированныйРежим(Ложь);
	
	// Если ФО "ИспользоватьХарактеристикиНоменклатуры" или "ИспользоватьСерииНоменклатурыСклад" выключены, то в СКД
	// не будет поля Характеристика или Серия, поэтому в ТаблицаНоменклатуры может не быть этой колонки.
	Если ТаблицаНоменклатуры.Колонки.Найти("ХарактеристикаПриходуемая") = Неопределено Тогда
		ТаблицаНоменклатуры.Колонки.Добавить("ХарактеристикаПриходуемая", 
			Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	КонецЕсли;
	Если ТаблицаНоменклатуры.Колонки.Найти("ХарактеристикаСписываемая") = Неопределено Тогда
		ТаблицаНоменклатуры.Колонки.Добавить("ХарактеристикаСписываемая", 
			Новый ОписаниеТипов("СправочникСсылка.ХарактеристикиНоменклатуры"));
	КонецЕсли;
	Если ТаблицаНоменклатуры.Колонки.Найти("НазначениеПриходуемое") = Неопределено Тогда
		ТаблицаНоменклатуры.Колонки.Добавить("НазначениеПриходуемое", 
			Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	КонецЕсли;
	Если ТаблицаНоменклатуры.Колонки.Найти("НазначениеСписываемое") = Неопределено Тогда
		ТаблицаНоменклатуры.Колонки.Добавить("НазначениеСписываемое", 
			Новый ОписаниеТипов("СправочникСсылка.Назначения"));
	КонецЕсли;
	Если ТаблицаНоменклатуры.Колонки.Найти("СерияПриходуемая") = Неопределено Тогда
		ТаблицаНоменклатуры.Колонки.Добавить("СерияПриходуемая", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	КонецЕсли;
	Если ТаблицаНоменклатуры.Колонки.Найти("СерияСписываемая") = Неопределено Тогда
		ТаблицаНоменклатуры.Колонки.Добавить("СерияСписываемая", Новый ОписаниеТипов("СправочникСсылка.СерииНоменклатуры"));
	КонецЕсли;
	
	
	Возврат ТаблицаНоменклатуры;
	
КонецФункции

// Добавляет команду создания объекта.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  Неопределено, СтрокаТаблицыЗначений - Добавить команду создать на основании помощник оформления складских актов
Функция ДобавитьКомандуСоздатьНаОснованииПомощникОформленияСкладскихАктов(КомандыСозданияНаОсновании) Экспорт
	Если ПравоДоступа("Просмотр", Метаданные.Обработки.ПомощникОформленияСкладскихАктов) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Обработчик = "СозданиеНаОснованииУТКлиент.ПомощникОформленияСкладскихАктов";
		КомандаСоздатьНаОсновании.Идентификатор = "ПомощникОформленияСкладскихАктов";
		КомандаСоздатьНаОсновании.Представление = НСтр("ru = 'Помощник оформления складских актов'");
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьОрдернуюСхемуПриОтраженииИзлишковНедостач";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

// Устанавливает условное оформление для поля 'ОперацияТекст' табличной части.
//
// Параметры:
//	Форма			- ФормаКлиентскогоПриложения	- форма, содержащая элементы, для установки условного оформления.
//	ИмяПоля			- Строка						- наименование элемента формы табличной части, содержащая сведения об операции.
//														Значение по умолчанию "ТоварыОперацияТекст".
//	ПутьКПолюОтбора - Строка						- полный путь к реквизиту 'ОперацияТекст' табличной части формы.
//														Значение по умолчанию "Объект.Товары.ОперацияТекст".
//
Процедура УстановитьУсловноеОформлениеОперацияТекст(Форма,
													ИмяПоля = "ТоварыОперацияТекст",
													ПутьКПолюОтбора = "Объект.Товары.ОперацияТекст") Экспорт
	
	ЭлементыФормы		= Форма.Элементы;
	УсловноеОформление	= Форма.УсловноеОформление;
	
	ОписанияОпераций = Новый Структура;
	ОписанияОпераций.Вставить("Списание",		НСтр("ru = 'Списание'"));
	ОписанияОпераций.Вставить("Оприходование",	НСтр("ru = 'Оприходование'"));
	ОписанияОпераций.Вставить("Порча",			НСтр("ru = 'Порча'"));
	ОписанияОпераций.Вставить("Пересортица",	НСтр("ru = 'Пересортица'"));
	
	Для Каждого ОперацияТекст Из ОписанияОпераций Цикл
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеФормыТЧ = ЭлементыФормы[ИмяПоля]; // ПолеФормы
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ПолеФормыТЧ.Имя);
		
		ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных(ПутьКПолюОтбора);
		ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ОтборЭлемента.ПравоеЗначение = ОперацияТекст.Ключ;
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Текст", ОперацияТекст.Значение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗначениеПараметраНастроек(Настройки, ИмяПараметра, Значение)
	
	Параметр = Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Значение;
		Параметр.Использование = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
