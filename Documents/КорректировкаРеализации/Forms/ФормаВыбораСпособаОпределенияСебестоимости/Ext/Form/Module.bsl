﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	ВалютаУправленческогоУчета = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегламентированногоУчета = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Параметры.Организация);
	ВводитьРеглУпрОтдельно = НЕ (ВалютаУправленческогоУчета = ВалютаРегламентированногоУчета);
	ИспользоватьНесколькоВидовЦен = ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВидовЦен");
	НастроитьФормуПоПараметрам(Параметры);
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СпособОпределенияСебестоимостиВручнуюПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СпособОпределенияСебестоимостиТекущийДокументПриИзменении(Элемент)
	
	УстановитьВидимость(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидЦеныПриИзменении(Элемент)
	
	ЗаполнитьСуммыПоВидуЦен();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаЗаполненияПриИзменении(Элемент)
	
	ЗаполнитьСуммыПоВидуЦен();

КонецПроцедуры

&НаКлиенте
Процедура СуммаУпрПриИзменении(Элемент)
	
	Если ТипНалогообложения <> ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС") Тогда
		Товары[0].СуммаБезНДС = Товары[0].СуммаСНДС;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОКЗакрыть(Команда)

	ОчиститьСообщения();
	Если ПроверитьЗаполнение() Тогда
		ПеренестиДанныеВДокумент();
	КонецЕсли;
		
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимость(Форма)
	
	Если Форма.СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.Вручную") Тогда
		Форма.Элементы.ГруппаСуммы.ТекущаяСтраница = Форма.Элементы.ГруппаВручнуюДанные;
		ПоказыватьСуммы = (Форма.Товары.Количество() = 1);
		Форма.Элементы.ГруппаУпр.Видимость = ПоказыватьСуммы;
		Форма.Элементы.ГруппаРегл.Видимость = ПоказыватьСуммы;
	Иначе
		Форма.Элементы.ГруппаСуммы.ТекущаяСтраница = Форма.Элементы.ГруппаВручнуюПустая;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСуммыПоВидуЦен()
	
	Если НЕ ЗначениеЗаполнено(ВидЦены) ИЛИ НЕ ЗначениеЗаполнено(ДатаЗаполнения) Тогда
		Элементы.НадписьНетЦеныНаДату.Видимость = Ложь;
		Возврат;
	КонецЕсли;
	
	СтруктураОтбораПоВидуЦен = Новый Структура;
	СтруктураОтбораПоВидуЦен.Вставить("Ссылка", ВидЦены);
	ЦенаВключаетНДС = Справочники.ВидыЦен.ВидЦеныИПризнакЦенаВключаетНДСПоУмолчанию(СтруктураОтбораПоВидуЦен).ЦенаВключаетНДС;
	
	СтруктураПересчетаСуммы = Новый Структура;
	СтруктураПересчетаСуммы.Вставить("ЦенаВключаетНДС", ЦенаВключаетНДС);
	СтруктураПересчетаСуммы.Вставить("НалогообложениеНДС", ТипНалогообложения);
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Дата", ДатаЗаполнения);
	ПараметрыЗаполнения.Вставить("Организация", Организация);
	ПараметрыЗаполнения.Вставить("Валюта", ВалютаДокумента);
	ПараметрыЗаполнения.Вставить("ВидЦены", ВидЦены);
	ПараметрыЗаполнения.Вставить("НалогообложениеНДС", ТипНалогообложения);
	ПараметрыЗаполнения.Вставить("ПоляЗаполнения", "Цена, ВидЦены");
	
	СтруктураДействий = Новый Структура;
	СтруктураДействий.Вставить("ПересчитатьСумму", "КоличествоУпаковок");
	СтруктураДействий.Вставить("ПересчитатьСуммуСНДС", СтруктураПересчетаСуммы);
	СтруктураДействий.Вставить("ПересчитатьСуммуНДС", СтруктураПересчетаСуммы);
	
	ЦеныПредприятияЗаполнениеСервер.ЗаполнитьЦены(
		Товары,
		, // Массив строк или структура отбора
		ПараметрыЗаполнения,
		СтруктураДействий);
		
		
	КоэффициентПересчетаДокУпр = ?(ВалютаДокумента = ВалютаУправленческогоУчета,
			1,
			РаботаСКурсамиВалютУТ.ПолучитьКоэффициентПересчетаИзВалютыВВалюту(ВалютаДокумента,
				ВалютаУправленческогоУчета,
				ДатаЗаполнения));
		
			
	НетЦены = Ложь;
	Для Каждого ТекущаяСтрока Из Товары Цикл
		
		СуммаБезНДС = ТекущаяСтрока.СуммаСНДС-ТекущаяСтрока.СуммаНДС;
		ТекущаяСтрока.СуммаСНДС = ТекущаяСтрока.СуммаСНДС * КоэффициентПересчетаДокУпр;
		ТекущаяСтрока.СуммаБезНДС = СуммаБезНДС * КоэффициентПересчетаДокУпр;
		
		
		Если ТекущаяСтрока.Цена = 0 Тогда
			НетЦены = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.НадписьНетЦеныНаДату.Видимость = НетЦены;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьФормуПоПараметрам(Параметры)
	
	Организация = Параметры.Организация;
	Партнер = Параметры.Партнер;
	Договор = Параметры.Договор;
	Соглашение = Параметры.Соглашение;
	ВалютаДокумента = Параметры.ВалютаДокумента;
	ТипНалогообложения = Параметры.ТипНалогообложения;
	
	Если ТипЗнч(Параметры.СтрокиТаблицыТовары) = Тип("Массив") Тогда
		
		Если Параметры.СтрокиТаблицыТовары.Количество() Тогда
			ПерваяСтрока = Параметры.СтрокиТаблицыТовары[0];
			ВидЦены = ПерваяСтрока.ВидЦены;
			ДатаЗаполнения = ПерваяСтрока.ДатаЗаполненияСебестоимостиПоВидуЦены;
			СпособОпределенияСебестоимости = ПерваяСтрока.СпособОпределенияСебестоимости;
		КонецЕсли;
		
		НомерСтроки = 0;
		Для Каждого ТекущаяСтрока Из Параметры.СтрокиТаблицыТовары Цикл
			
			НомерСтроки = НомерСтроки + 1;
			НоваяСтрока = Товары.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
			
			НоваяСтрока.НомерСтроки = НомерСтроки;
			
			Если ВидЦены <> ТекущаяСтрока.ВидЦены Тогда
				ВидЦены = Неопределено;
			КонецЕсли;
			
			Если ДатаЗаполнения <> ТекущаяСтрока.ДатаЗаполненияСебестоимостиПоВидуЦены Тогда
				ДатаЗаполнения = Неопределено;
			КонецЕсли;
			
			Если СпособОпределенияСебестоимости <> ТекущаяСтрока.СпособОпределенияСебестоимости Тогда
				СпособОпределенияСебестоимости = Перечисления.СпособыОпределенияСебестоимости.ИзТекущегоДокумента;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"ГруппаРеглУпр",
		"Видимость",
		ВводитьРеглУпрОтдельно);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"ГруппаСебестоимость",
		"Видимость",
		НЕ ВводитьРеглУпрОтдельно);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"ГруппаВидЦен",
		"Видимость",
		ИспользоватьНесколькоВидовЦен);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"УпрБезНДС",
		"Видимость",
		ТипНалогообложения = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС);
		
	ОбщегоНазначенияУТКлиентСервер.УстановитьСвойствоЭлементовФормы(Элементы,
		"СебестоимостьБезНДС",
		"Видимость",
		ТипНалогообложения = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС);
	
	
	Если ВводитьРеглУпрОтдельно Тогда
		Если ТипНалогообложения = Перечисления.ТипыНалогообложенияНДС.ПродажаОблагаетсяНДС Тогда
			ТекстЗаголовкаУпр = НСтр("ru = 'Упр. учет с НДС (%1):'");
			ТекстЗаголовкаУпрБезНДС = НСтр("ru = 'Упр. учет без НДС (%1):'");
			Элементы.НадписьУпрБезНДС.Заголовок = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаУпрБезНДС, ВалютаУправленческогоУчета);
		Иначе
			ТекстЗаголовкаУпр = НСтр("ru = 'Упр. учет (%1):'");
		КонецЕсли;
		Элементы.НадписьУпр.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаУпр, ВалютаУправленческогоУчета);
		
	Иначе
		ТекстЗаголовкаСебестоимость = НСтр("ru = 'Себестоимость с НДС (%1):'");
		ТекстЗаголовкаСебестоимостьБезНДС = НСтр("ru = 'Себестоимость без НДС (%1):'");
		Элементы.НадписьСебестоимость.Заголовок = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаСебестоимость, ВалютаУправленческогоУчета);
		Элементы.НадписьСебестоимостьБезНДС.Заголовок = 
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовкаСебестоимостьБезНДС, ВалютаУправленческогоУчета);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		Отказ = Истина;
		ПоказатьВопрос(Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект),
			НСтр("ru = 'Данные были изменены. Перенести изменения в документ?'"),
			РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Ответ = РезультатВопроса;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Если ПроверитьЗаполнение() Тогда
			ВыполняетсяЗакрытие = Истина;
			ПеренестиДанныеВДокумент();
		КонецЕсли;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПеренестиДанныеВДокумент()

	Модифицированность = Ложь;
	
	СтрокиТаблицыТовары = Новый Массив;
	
	Для Каждого ТекущаяСтрока Из Товары Цикл
		
		ПараметрыСтроки = ОбщегоНазначенияУТКлиент.НовыйЭлементМассивТовары();
		
		ПараметрыСтроки.СпособОпределенияСебестоимости = СпособОпределенияСебестоимости;
		ПараметрыСтроки.Идентификатор = ТекущаяСтрока.Идентификатор;
		
		Если СпособОпределенияСебестоимости = ПредопределенноеЗначение("Перечисление.СпособыОпределенияСебестоимости.Вручную") Тогда
			ПараметрыСтроки.ВидЦеныСебестоимости = ВидЦены;
			ПараметрыСтроки.ДатаЗаполненияСебестоимостиПоВидуЦены = ДатаЗаполнения;
			ПараметрыСтроки.Себестоимость = ТекущаяСтрока.СуммаСНДС;
			ПараметрыСтроки.СебестоимостьБезНДС = ТекущаяСтрока.СуммаБезНДС;
			
			
		Иначе
			ПараметрыСтроки.ВидЦеныСебестоимости = Неопределено;
			ПараметрыСтроки.ДатаЗаполненияСебестоимостиПоВидуЦены = Дата(1, 1, 1);
			ПараметрыСтроки.Себестоимость = 0;
			ПараметрыСтроки.СебестоимостьБезНДС = 0;
			
			
		КонецЕсли;
		
		СтрокиТаблицыТовары.Добавить(ПараметрыСтроки);
		
	КонецЦикла;
	
	ПараметрыЗакрытия = ОбщегоНазначенияУТКлиент.НоваяСтруктураТовары();
	ПараметрыЗакрытия.СтрокиТаблицыТовары = СтрокиТаблицыТовары;
	Закрыть(ПараметрыЗакрытия);
						
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ВыполняетсяЗакрытие = Ложь;

#КонецОбласти



