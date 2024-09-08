﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		
		ВладелецОтбор = Параметры.Отбор.Владелец;
		Элементы.Список.Отображение = ОтображениеТаблицы.Дерево;
		Элементы.ВладелецОтбор.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	
	// ИнтеграцияС1СДокументооборотом
	ИнтеграцияС1СДокументооборотБазоваяФункциональность.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец ИнтеграцияС1СДокументооборотом
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВладелецОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Владелец", ВладелецОтбор, , ,
																			ЗначениеЗаполнено(ВладелецОтбор));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	СтандартнаяОбработка = Ложь;
	
	ПриемникВладелец = ПолучитьВладельцаПриемника(Строка);
	
	Для Каждого СтрокаМассива Из ПараметрыПеретаскивания.Значение Цикл
		
		Если ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Перемещение Тогда
			ПеренестиИсточникВПриемник(СтрокаМассива, Строка, ПриемникВладелец);
		Иначе
			СкопироватьИсточникВПриемник(СтрокаМассива, Строка, ПриемникВладелец);
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Выполняет проверку перемещения и перемещение элементов в справочнике.
//
// Параметры:
//	Источник - СправочникСсылка.ЭквайринговыеТерминалы - перемещаемый элемент справочника.
//	Приемник - СправочникСсылка.ЭквайринговыеТерминалы - элемент (группа) справочника, в который выполняется перемещение
// источника.
//	ПриемникВладелец - СправочникСсылка.ДоговорыЭквайринга - Владелец элемента (группы), в который выполняется перемещение
// источника.
//
&НаСервереБезКонтекста
Процедура ПеренестиИсточникВПриемник(Источник, Приемник, ПриемникВладелец)
	
	Если ЗначениеЗаполнено(ПриемникВладелец)
		И ПриемникВладелец <> Источник.Владелец Тогда
		
		ТекстСообщения = СтрШаблон(НСтр("ru = 'Невозможно переместить элемент %1:
							|	договор подключения к платежной системе у группы не соответствует перемещаемому элементу'"), Строка(Источник.Наименование));
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, Источник);
		
	Иначе
		
		Если Источник.Родитель <> Приемник Тогда
			
			ИсточникОбъект = Источник.ПолучитьОбъект();
			ИсточникОбъект.Родитель = Приемник;
			ИсточникОбъект.Записать();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет копирование элементов в справочнике. В случае, если источник и приемник подченены различным договорам, то 
// новый элемент создается с владельцем по приемнику.
//
// Параметры:
//	Источник - СправочникСсылка.ЭквайринговыеТерминалы - копируемый элемент справочника.
//	Приемник - СправочникСсылка.ЭквайринговыеТерминалы - элемент (группа) справочника, в который выполняется копирование
// источника.
//	ПриемникВладелец - СправочникСсылка.ДоговорыЭквайринга - Владелец элемента (группы), в который выполняется перемещение
// источника.
//
&НаСервереБезКонтекста
Процедура СкопироватьИсточникВПриемник(Источник, Приемник, ПриемникВладелец)
	
	НовыйЭлемент = Справочники.ЭквайринговыеТерминалы.СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(НовыйЭлемент, Источник, , "Родитель, Владелец");
	НовыйЭлемент.Родитель = Приемник;
	НовыйЭлемент.Владелец = ПриемникВладелец;
	НовыйЭлемент.Записать();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВладельцаПриемника(Приемник)
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Приемник, "Владелец");
	
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	ИнтеграцияС1СДокументооборотБазоваяФункциональностьКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(
		Команда,
		ЭтотОбъект,
		Элементы.Список);
	
КонецПроцедуры
// Конец ИнтеграцияС1СДокументооборотом

#КонецОбласти
