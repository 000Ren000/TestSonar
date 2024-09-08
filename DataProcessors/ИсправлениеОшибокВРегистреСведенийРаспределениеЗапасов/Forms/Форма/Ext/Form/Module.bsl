﻿#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НайтиОшибки(Команда)
	
	ДлительнаяОперация = НайтиОшибкиВФоне();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		ДлительнаяОперация,
		Новый ОписаниеОповещения("НайтиОшибкиВФонеЗавершение", ЭтотОбъект),
		ПараметрыОжидания);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсправитьОшибки(Команда)
	
	ОчиститьСообщения();
	ДлительнаяОперация = ИсправитьОшибкиВФоне();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(
		ДлительнаяОперация,
		Новый ОписаниеОповещения("ИсправитьОшибкиВФонеЗавершение", ЭтотОбъект),
		ПараметрыОжидания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция НайтиОшибкиВФоне()
	
	ПараметрыПроцедуры = Новый Структура();
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Исправление ошибок в регистре сведений ""Распределение запасов"": Поиск ошибок.'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработка.ИсправлениеОшибокВРегистреСведенийРаспределениеЗапасов.МодульОбъекта.ОшибкиПроверкиКорректностиЗаписейРегистраСведенийРаспределениеЗапасовВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура НайтиОшибкиВФонеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, Результат.КраткоеПредставлениеОшибки);
	Иначе
		НайтиОшибкиВФонеЗавершениеНаСервере(Результат.АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура НайтиОшибкиВФонеЗавершениеНаСервере(АдресРезультата)
	
	ТаблицаОшибокВременная = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если Не ЗначениеЗаполнено(ТаблицаОшибокВременная) Тогда
		ТаблицаОшибок.Очистить();
		Возврат;
	КонецЕсли;
	ТаблицаОшибок.Загрузить(ТаблицаОшибокВременная);
	
КонецПроцедуры

&НаСервере
Функция ИсправитьОшибкиВФоне()
	
	Аналитики = ТаблицаОшибок.Выгрузить(Новый Массив(), "Номенклатура,Характеристика,Склад,Назначение");
	Для Каждого Идентификатор Из Элементы.ТаблицаОшибок.ВыделенныеСтроки Цикл
		СтрокаТаблицы = ТаблицаОшибок.НайтиПоИдентификатору(Идентификатор);
		ЗаполнитьЗначенияСвойств(Аналитики.Добавить(), СтрокаТаблицы);
	КонецЦикла;
	ПараметрыПроцедуры = Новый Структура("Аналитики", Аналитики);
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Исправление ошибок в регистре сведений ""Распределение запасов"": Исправление ошибок.'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне("Обработка.ИсправлениеОшибокВРегистреСведенийРаспределениеЗапасов.МодульОбъекта.ИсправитьОшибкиРегистраСведенийРаспределениеЗапасовВФоне",
		ПараметрыПроцедуры, ПараметрыВыполнения);
	
КонецФункции

&НаКлиенте
Процедура ИсправитьОшибкиВФонеЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, Результат.КраткоеПредставлениеОшибки);
	Иначе
		ОчиститьСообщения();
		ИсправитьОшибкиВФонеЗавершениеНаСервере(Результат.АдресРезультата);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИсправитьОшибкиВФонеЗавершениеНаСервере(АдресРезультата)
	РезультатОбработки = ПолучитьИзВременногоХранилища(АдресРезультата);
	Для Каждого ТекстСообщения Из РезультатОбработки.Сообщения Цикл
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
