﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияУТ.НастроитьПодключаемоеОборудование(ЭтаФорма);
	Склад     = Параметры.Склад;
	Помещение = Параметры.Помещение;
	
	СхемаКомпоновкиДанных = Документы.ОтборРазмещениеТоваров.ПолучитьМакет("ОтборЯчеекДляЗаполнения");
		
	URLСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());

	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы);

	ОтборЯчеек.Инициализировать(ИсточникНастроек);
	ОтборЯчеек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	УстановитьЗначениеПараметраНастроек(ОтборЯчеек.Настройки, "Склад" , Склад);
	УстановитьЗначениеПараметраНастроек(ОтборЯчеек.Настройки, "Помещение", Помещение);

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПриОткрытииФормы(Неопределено, ЭтаФорма, "СканерШтрихкода");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	МенеджерОборудованияКлиент.НачатьОтключениеОборудованиеПриЗакрытииФормы(Неопределено, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ПодключаемоеОборудование
	Если Источник = "ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия = "ScanData" И МенеджерОборудованияУТКлиент.ЕстьНеобработанноеСобытие() Тогда
			ОбработатьШтрихкоды(МенеджерОборудованияУТКлиент.ПреобразоватьДанныеСоСканераВСтруктуру(Параметр));
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	ОчиститьСообщения();
	Адрес = АдресЯчеекВХранилище(ВладелецФормы.УникальныйИдентификатор);
	Если ЗначениеЗаполнено(Адрес) Тогда
		Закрыть(Адрес);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокЯчеекПоОтбору(Команда)
	Если Ячейки.Количество() > 0 Тогда
		Ответ = Неопределено;

		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьСписокЯчеекПоОтборуЗавершение", ЭтотОбъект), НСтр("ru = 'Перед заполнением список ячеек будет очищен. Продолжить?'"), РежимДиалогаВопрос.ДаНет);
        Возврат;
	КонецЕсли;
	
	ЗаполнитьСписокЯчеекПоОтборуСервер();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокЯчеекПоОтборуЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    Ответ = РезультатВопроса;
    Если Ответ <> КодВозвратаДиалога.Да Тогда
        Возврат;
    КонецЕсли;
    
    ЗаполнитьСписокЯчеекПоОтборуСервер();

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ШтрихкодыИТорговоеОборудование

&НаСервере
Процедура ОбработатьШтрихкоды(Данные)
	
	Менеджеры = Новый Массив();
	Менеджеры.Добавить(Справочники.СкладскиеЯчейки);
	МассивСсылок = ШтрихкодированиеПечатныхФорм.ПолучитьСсылкуПоШтрихкодуТабличногоДокумента(Данные.Штрихкод, Менеджеры);
	
	Если МассивСсылок.Количество() > 0 Тогда
    	Ячейка = МассивСсылок[0];
	Иначе
		ТекстСообщения = НСтр("ru = 'Складская ячейка со штрихкодом %Штрихкод% не найдена'");
	    ТекстСообщения = СтрЗаменить(ТекстСообщения,"%Штрихкод%",Данные.Штрихкод);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	НоваяСтрока = Ячейки.Добавить();
	НоваяСтрока.Ячейка        = Ячейка;
				
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Функция АдресЯчеекВХранилище(УникальныйИдентификаторФормы)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Ячейки.Ячейка
	|ПОМЕСТИТЬ Ячейки
	|ИЗ
	|	&Ячейки КАК Ячейки
	|ГДЕ
	|	Ячейки.Ячейка <> ЗНАЧЕНИЕ(Справочник.СкладскиеЯчейки.ПустаяСсылка)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Ячейки.Ячейка
	|ИЗ
	|	Ячейки КАК Ячейки
	|
	|УПОРЯДОЧИТЬ ПО
	|	Ячейки.Ячейка.ПорядокОбхода,
	|	Ячейки.Ячейка.Код";
	Запрос.УстановитьПараметр("Ячейки", Ячейки.Выгрузить());
	
	ТаблицаЯчеек = Запрос.Выполнить().Выгрузить();
	
	Если ТаблицаЯчеек.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'Не указано ни одной ячейки'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,"Ячейки");
		Возврат "";
	Иначе
		Возврат ПоместитьВоВременноеХранилище(ТаблицаЯчеек,УникальныйИдентификаторФормы);
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура УстановитьЗначениеПараметраНастроек(Настройки, ИмяПараметра, Значение)

	Параметр = Настройки.ПараметрыДанных.Элементы.Найти(ИмяПараметра);
	
	Если Параметр <> Неопределено Тогда
		Параметр.Значение = Значение;
		Параметр.Использование = Истина;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЯчеекПоОтборуСервер()
	СхемаКомпоновкиДанных = Документы.ОтборРазмещениеТоваров.ПолучитьМакет("ОтборЯчеекДляЗаполнения");
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки   = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, ОтборЯчеек.ПолучитьНастройки(),,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	Ячейки.Загрузить(ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных));
КонецПроцедуры

#КонецОбласти

#КонецОбласти
