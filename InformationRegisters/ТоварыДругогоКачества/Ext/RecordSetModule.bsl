﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Товары = ЭтотОбъект.Выгрузить();
	КолонкаНоменклатураБрак = Товары.Колонки.НоменклатураБрак; // КолонкаТаблицыЗначений
	КолонкаНоменклатураБрак.Имя = "НоменклатураОприходование";
	Товары.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число"));
	
	НоменклатураСервер.ПроверитьВидНоменклатурыОприходования(ЭтотОбъект, Отказ,, Товары);
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбобщенныйУчетНекачественныхТоваров") Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Товары.Номенклатура КАК Номенклатура,
		|	Товары.НоменклатураОприходование КАК НоменклатураБрак
		|ПОМЕСТИТЬ Товары
		|ИЗ
		|	&Товары КАК Товары
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.НоменклатураБрак,
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВложенныйЗапрос.Номенклатура) КАК Номенклатура
		|ИЗ
		|	(ВЫБРАТЬ
		|		Товары.НоменклатураБрак КАК НоменклатураБрак,
		|		Товары.Номенклатура КАК Номенклатура
		|	ИЗ
		|		Товары КАК Товары
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ТоварыДругогоКачества.НоменклатураБрак,
		|		ТоварыДругогоКачества.Номенклатура
		|	ИЗ
		|		Товары КАК Товары
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ТоварыДругогоКачества КАК ТоварыДругогоКачества
		|			ПО Товары.НоменклатураБрак = ТоварыДругогоКачества.НоменклатураБрак) КАК ВложенныйЗапрос
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапрос.НоменклатураБрак
		|
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВложенныйЗапрос.Номенклатура) > 1";
		
		Запрос.УстановитьПараметр("Товары", Товары); 
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ТекстСообщения = НСтр("ru = 'Нельзя связывать номенклатуру ""%НоменклатураБрак%"" более чем с одной номенклатурой исходного качества.'");	
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НоменклатураБрак%", Выборка.НоменклатураБрак);
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли