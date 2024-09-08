﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТаблицаНайдено.Загрузить(ПолучитьИзВременногоХранилища(Параметры.АдресВременногоХранилищаТаблицаНайдено));
	Элементы.ПродолжитьЗапись.Видимость = Параметры.ЭтоЗапись
										И Пользователи.РолиДоступны("ВводИнформацииПоНоменклатуреБезКонтроля")
										И ТаблицаНайдено.НайтиСтроки(Новый Структура("НайденоПоНаименованию", Истина)).Количество() = 0;
										
	Если ТаблицаНайдено.Количество() > 0
		И ТипЗнч(ТаблицаНайдено[0].Ссылка) = Тип("СправочникСсылка.ХарактеристикиНоменклатуры") Тогда
		ЭтоХарактеристики = Истина;
	Иначе
		ЭтоХарактеристики = Ложь;
	КонецЕсли;
	
	Элементы.ТаблицаНайденоНайденоПоШтрихкоду.Видимость = Не ЭтоХарактеристики;
	
	Если ЭтоХарактеристики Тогда
		Элементы.ТаблицаНайденоСсылка.Заголовок = НСтр("ru = 'Характеристика'");
		Элементы.ПояснениеНайдено.Заголовок     = НСтр("ru = 'Найдены характеристики с аналогичными данными. Примите решение о дальнейших действиях.'");
	Иначе
		Элементы.ТаблицаНайденоСсылка.Заголовок = НСтр("ru = 'Номенклатура'");
		Элементы.ПояснениеНайдено.Заголовок     = НСтр("ru = 'Найдена номенклатура с аналогичными данными. Примите решение о дальнейших действиях.'");
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработкаКоманд

&НаКлиенте
Процедура ВыбратьСуществующую(Команда)
	
	ОчиститьСообщения();
	Если Элементы.ТаблицаНайдено.ТекущиеДанные = Неопределено Тогда
		ТекстСообщения = НСтр("ru = 'Номенклатура не выбрана'");
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,
		,
		"ТаблицаНайдено");
		Возврат;
	КонецЕсли;
	
	СтруктураВозврата = НоменклатураКлиент.НовыйРезультатОбработкиЗавершения();
		
	СтруктураВозврата.Действие = "ВыбратьСуществующую";
	СтруктураВозврата.Ссылка = Элементы.ТаблицаНайдено.ТекущиеДанные.Ссылка;
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗаполнение(Команда)
	
	СтруктураВозврата = НоменклатураКлиент.НовыйРезультатОбработкиЗавершения();
	
	СтруктураВозврата.Действие = "ПродолжитьЗаполнение";
	СтруктураВозврата.Ссылка = Неопределено;
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьЗапись(Команда)
	
	СтруктураВозврата = НоменклатураКлиент.НовыйРезультатОбработкиЗавершения();
	
	СтруктураВозврата.Действие = "ПродолжитьЗапись";
	СтруктураВозврата.Ссылка = Неопределено;
	Закрыть(СтруктураВозврата);
	
КонецПроцедуры

#КонецОбласти