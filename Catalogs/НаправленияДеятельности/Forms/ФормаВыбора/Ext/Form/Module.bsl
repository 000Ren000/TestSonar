﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РежимВыбора = "Активные";
	
	НастроитьОтборыНаФорме();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РежимВыбораПриИзменении(Элемент)
	РежимВыбораПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура РежимВыбораПриИзмененииНаСервере()
	
	НовыйСтатус = Перечисления.СтатусыНаправленияДеятельности.Используется;
	Если РежимВыбора = "Все" Тогда
		НовыйСтатус = Перечисления.СтатусыНаправленияДеятельности.ПустаяСсылка();
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Статус",
			НовыйСтатус,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			ЗначениеЗаполнено(НовыйСтатус));
	
КонецПроцедуры

#КонецОбласти

#Область Служебные

&НаСервере
Процедура НастроитьОтборыНаФорме()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Статус",
		Перечисления.СтатусыНаправленияДеятельности.Используется,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		Истина);
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Свойство("УчетЗатратИлиРасчетовСПоставщиками") И Параметры.Отбор.УчетЗатратИлиРасчетовСПоставщиками Тогда
			ОтборГруппаИЛИ = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ОтборГруппаИЛИ.Использование = Истина;
			ОтборГруппаИЛИ.Представление = НСтр("ru = 'Расчеты с поставщиками или затраты с обособлением'");
			ОтборГруппаИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
			ОтборГруппаИЛИ.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
			
			ОтборУчетЗатрат = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборУчетЗатрат.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетЗатрат");
			ОтборУчетЗатрат.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
			ОтборУчетЗатрат.Использование    = Истина;
			ОтборУчетЗатрат.ПравоеЗначение   = Истина;
			
			ОтборУчетРасчетовСПоставщиками = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборУчетРасчетовСПоставщиками.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетРасчетовСПоставщиками");
			ОтборУчетРасчетовСПоставщиками.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
			ОтборУчетРасчетовСПоставщиками.Использование    = Истина;
			ОтборУчетРасчетовСПоставщиками.ПравоеЗначение   = Истина;
		КонецЕсли;
		
		Если Параметры.Отбор.Свойство("ТипНаправленияДеятельности") Тогда
			ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
						Список,
						"ТипНаправленияДеятельности",
						Параметры.Отбор.ТипНаправленияДеятельности,
						ВидСравненияКомпоновкиДанных.ВСписке,
						,
						Истина);
		КонецЕсли;
		
	КонецЕсли;
	Если Параметры.Свойство("Ссылка") Тогда
		
		Если ТипЗнч(Параметры.Ссылка) = Тип("СправочникСсылка.ДоговорыКонтрагентов") 
			И Параметры.Свойство("ТипДоговора") Тогда
			
			Если Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СПокупателем
				ИЛИ Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СКомиссионером Тогда
				
				Параметры.Отбор.Вставить("УчетДоходов", Истина);
			
			ИначеЕсли Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СПоставщиком
				ИЛИ Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СКомитентом
				ИЛИ Параметры.ТипДоговора = Перечисления.ТипыДоговоров.Импорт
				ИЛИ Параметры.ТипДоговора = Перечисления.ТипыДоговоров.ВвозИзЕАЭС
				//++ Устарело_Переработка24
				ИЛИ Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СПереработчиком
				//-- Устарело_Переработка24
				ИЛИ Параметры.ТипДоговора = Перечисления.ТипыДоговоров.СПоклажедателем Тогда
				
				ОтборГруппаИЛИ = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
				ОтборГруппаИЛИ.Использование = Истина;
				ОтборГруппаИЛИ.Представление = НСтр("ru = 'Расчеты с поставщиками или затраты с обособлением'");
				ОтборГруппаИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
				ОтборГруппаИЛИ.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;
				
				ОтборУчетЗатрат = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ОтборУчетЗатрат.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетЗатрат");
				ОтборУчетЗатрат.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
				ОтборУчетЗатрат.Использование    = Истина;
				ОтборУчетЗатрат.ПравоеЗначение   = Истина;
				
				ОтборУчетРасчетовСПоставщиками = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
				ОтборУчетРасчетовСПоставщиками.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетРасчетовСПоставщиками");
				ОтборУчетРасчетовСПоставщиками.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
				ОтборУчетРасчетовСПоставщиками.Использование    = Истина;
				ОтборУчетРасчетовСПоставщиками.ПравоеЗначение   = Истина;
							
			Иначе
				
				Параметры.Отбор.Вставить("УчетЗатрат", Истина);
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ДвижениеПрочихАктивовПассивов")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациямиОСписании")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ПересортицаТоваров")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("ДокументСсылка.ПрочиеДоходыРасходы")
			ИЛИ ТипЗнч(Параметры.Ссылка) = Тип("СправочникСсылка.ДоговорыМеждуОрганизациями") Тогда
			
			ОтборГруппаИЛИ = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
			ОтборГруппаИЛИ.Использование = Истина;
			ОтборГруппаИЛИ.Представление = НСтр("ru = 'список комбинаций проект/статус'");
			ОтборГруппаИЛИ.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
			ОтборГруппаИЛИ.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный;

			ОтборПоДоходу = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборПоДоходу.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетДоходов");
			ОтборПоДоходу.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
			ОтборПоДоходу.Использование    = Истина;
			ОтборПоДоходу.ПравоеЗначение   = Истина;

			ОтборПоЗатратам = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборПоЗатратам.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("УчетЗатрат");
			ОтборПоЗатратам.ВидСравнения   = ВидСравненияКомпоновкиДанных.Равно;
			ОтборПоЗатратам.Использование  = Истина;
			ОтборПоЗатратам.ПравоеЗначение = Истина;
			
			ОтборУчетРасчетовСПоставщиками = ОтборГруппаИЛИ.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ОтборУчетРасчетовСПоставщиками.ЛевоеЗначение    = Новый ПолеКомпоновкиДанных("УчетРасчетовСПоставщиками");
			ОтборУчетРасчетовСПоставщиками.ВидСравнения     = ВидСравненияКомпоновкиДанных.Равно;
			ОтборУчетРасчетовСПоставщиками.Использование    = Истина;
			ОтборУчетРасчетовСПоставщиками.ПравоеЗначение   = Истина;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти
