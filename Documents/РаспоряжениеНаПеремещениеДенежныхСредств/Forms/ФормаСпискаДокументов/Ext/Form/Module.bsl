﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	
	ИспользоватьНесколькоРасчетныхСчетов	= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоРасчетныхСчетов");
	ИспользоватьНесколькоКасс				= ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс");
	УправлениеЭлементамиФормы();
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаГлобальныеКоманды);
	// Конец ИнтеграцияС1СДокументооборотом

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);
	
	СтандартныеПодсистемыСервер.УстановитьУсловноеОформлениеПоляДата(ЭтотОбъект, "Список.Дата", Элементы.СписокДата.Имя);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	Организация = Настройки.Получить("Организация");
	ДатаОплаты = Настройки.Получить("ДатаОплаты");
	Статус = Настройки.Получить("Статус");
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура СтатусОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПлатежаОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическогоСписка();
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоступлениеДенежныхСредствИзБанка(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПоступлениеДенежныхСредствИзБанка"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьВыдачаДенежныхСредствВДругуюКассу(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ВыдачаДенежныхСредствВДругуюКассу"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПеречислениеДенежныхСредствНаДругойСчет(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПеречислениеДенежныхСредствНаДругойСчет"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнкассациюВБанк(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ИнкассацияДенежныхСредствВБанк"));
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьИнкассациюИзБанка(Команда)
	
	СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.СнятиеНаличныхДенежныхСредств"));
	
КонецПроцедуры

// Функция используется в автотесте процесса продаж.
//
&НаКлиенте
Процедура АвтоТест_УстановитьСтатусКОплате(Команда) Экспорт
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке распоряжений будет установлен статус ""К оплате"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("АвтоТест_УстановитьСтатусКОплатеЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоТест_УстановитьСтатусКОплатеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "КОплате");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='К оплате'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСогласовано(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке распоряжений будет установлен статус ""Согласовано"". Продолжить?'");
	Ответ = Неопределено;
	
	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусСогласованоЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусСогласованоЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
	
	
	Ответ = РезультатВопроса;
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ОчиститьСообщения();
	КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Согласовано");
	
	ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(
		Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Согласовано'"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласовано(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке распоряжений будет установлен статус ""Не согласовано"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусНеСогласованоЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусНеСогласованоЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "НеСогласовано");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Не согласовано'"));

КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтклонено(Команда)
	
	ВыделенныеСтроки = ОбщегоНазначенияУТКлиент.ПроверитьПолучитьВыделенныеВСпискеСсылки(Элементы.Список);
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='У выделенных в списке распоряжений будет установлен статус ""Отклонено"". Продолжить?'");
	Ответ = Неопределено;

	ПоказатьВопрос(Новый ОписаниеОповещения("УстановитьСтатусОтклоненоЗавершение", ЭтотОбъект, Новый Структура("ВыделенныеСтроки", ВыделенныеСтроки)), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСтатусОтклоненоЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
    
    ВыделенныеСтроки = ДополнительныеПараметры.ВыделенныеСтроки;
    
    
    Ответ = РезультатВопроса;
    Если Ответ = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
    
    ОчиститьСообщения();
    КоличествоОбработанных = ОбщегоНазначенияУТВызовСервера.УстановитьСтатусДокументов(ВыделенныеСтроки, "Отклонено");
    
    ОбщегоНазначенияУТКлиент.ОповеститьПользователяОбУстановкеСтатуса(Элементы.Список, КоличествоОбработанных, ВыделенныеСтроки.Количество(), НСтр("ru='Отклонено'"));

КонецПроцедуры

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УправлениеЭлементамиФормы

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	Элементы.СписокСоздатьПеречислениеДенежныхСредствНаДругойСчет.Видимость = ИспользоватьНесколькоРасчетныхСчетов;
	Элементы.СписокСоздатьВыдачаДенежныхСредствВДругуюКассу.Видимость = ИспользоватьНесколькоКасс;
	
	Элементы.СписокСоздатьВыдачаДенежныхСредствВДругуюКассу1.Видимость = ИспользоватьНесколькоРасчетныхСчетов;
	Элементы.СписокСоздатьПеречислениеДенежныхСредствНаДругойСчет1.Видимость = ИспользоватьНесколькоКасс;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСписокОрганизаций()
	
	Элементы.СписокОрганизация.Видимость = Не ЗначениеЗаполнено(Организация);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборДинамическогоСписка()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"ДатаПлатежа",
		ДатаПлатежа.Дата,
		ВидСравненияКомпоновкиДанных.МеньшеИлиРавно,, ЗначениеЗаполнено(ДатаПлатежа.Дата));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Организация", Организация, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Организация));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Статус", Статус, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(Статус));
	
	УстановитьВидимостьСписокОрганизаций();
	
КонецПроцедуры

#КонецОбласти

#Область СозданиеДокументов

&НаКлиенте
Процедура СоздатьРаспоряжениеНаПеремещениеДенежныхСредств(ХозяйственнаяОперация)

	СтруктураОснование = Новый Структура("ХозяйственнаяОперация, Организация", ХозяйственнаяОперация, Организация);
	СтруктураПараметры = Новый Структура("Основание", СтруктураОснование);
	ОткрытьФорму("Документ.РаспоряжениеНаПеремещениеДенежныхСредств.ФормаОбъекта", СтруктураПараметры, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

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

#КонецОбласти

#КонецОбласти
