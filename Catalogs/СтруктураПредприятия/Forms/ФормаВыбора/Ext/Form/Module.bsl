﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("ПодразделениеДиспетчерИлиПроизводственноеПодразделение") Тогда
		ГруппаИли = Список.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
		ГруппаИли.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
		ГруппаИли.Использование = Истина;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИли, "ПодразделениеДиспетчер", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(ГруппаИли, "ПроизводственноеПодразделение", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	КонецЕсли;
	
	Если Параметры.Свойство("СсылкаНеВСписке") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", Параметры.СсылкаНеВСписке, ВидСравненияКомпоновкиДанных.НеВСписке, "СсылкаНеВСписке", Истина);
	КонецЕсли;
	
	НастроитьОтображениеСписка();
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаСервере
Процедура СписокПриЗагрузкеПользовательскихНастроекНаСервере(Элемент, Настройки)
	
	НастроитьОтображениеСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат) Экспорт
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьОтображениеСписка()
	
	Если Элементы.Список.Отображение = ОтображениеТаблицы.Список Тогда
		Возврат;
	КонецЕсли;
	
	РазрешенныеПодразделения = УправлениеДоступом.РазрешенныеЗначенияДляДинамическогоСписка(Список.ОсновнаяТаблица, Тип("СправочникСсылка.СтруктураПредприятия"));
	Если РазрешенныеПодразделения <> Неопределено Тогда
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	КонецЕсли;
	
	Если Параметры.Свойство("Отбор")
		И (Параметры.Отбор.Свойство("ВариантОбособленногоУчетаТоваров")
			ИЛИ Параметры.Отбор.Свойство("ПроизводственноеПодразделение")
			ИЛИ Параметры.Отбор.Свойство("ПроизводствоПоЗаказам")
			ИЛИ Параметры.Отбор.Свойство("ПроизводствоБезЗаказов")
			ИЛИ Параметры.Отбор.Свойство("ИспользуетсяСписаниеЗатратНаВыпуск")
			ИЛИ Параметры.Отбор.Свойство("ИспользоватьПооперационноеУправление")
			ИЛИ Параметры.Отбор.Свойство("ИспользоватьПооперационноеПланирование")
			ИЛИ Параметры.Отбор.Свойство("ПодразделениеДиспетчер")
			ИЛИ Параметры.Отбор.Свойство("ПодразделениеДиспетчерИлиПроизводственноеПодразделение")
			ИЛИ Параметры.Отбор.Свойство("ИспользоватьСменныеЗадания")
			ИЛИ Параметры.Отбор.Свойство("ИспользоватьПроизводственныеУчастки")) Тогда
		// Если установлен отбор то список должен быть не иерахическим
		Элементы.Список.Отображение = ОтображениеТаблицы.Список;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
