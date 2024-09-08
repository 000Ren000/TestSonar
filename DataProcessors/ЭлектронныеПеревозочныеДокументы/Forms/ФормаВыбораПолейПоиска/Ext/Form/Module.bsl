﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗначениеВРеквизитФормы(ОбменСГИСЭПД.ДеревоПолейДляПоиска(), "Дерево");

КонецПроцедуры

&НаКлиенте
Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ТекущиеДанные = Элементы.Дерево.ТекущиеДанные;
	
	Если ТекущиеДанные.ВидГруппы > 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Для поиска можно выбрать только поля данных. По группам поиск не возможен.'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("Значение", ТекущиеДанные.Реквизит);
	Результат.Вставить("ТипДанных", ТекущиеДанные.Тип);
	Результат.Вставить("Представление", ТекущиеДанные.Представление + " (" + ТекущиеДанные.Реквизит + ")");
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьТехническиеПоля(Команда)
	
	Элементы.ДеревоРеквизит.Видимость = Не Элементы.ДеревоРеквизит.Видимость;
	Элементы.ДеревоУзел.Видимость = Не Элементы.ДеревоУзел.Видимость;
	
	Элементы.ДеревоПоказатьТехническиеПоля.Заголовок = ?(Элементы.ДеревоРеквизит.Видимость, 
		НСтр("ru='Скрыть технические поля'"), 
		НСтр("ru='Показать технические поля'"));

КонецПроцедуры

&НаКлиенте
Процедура ДеревоПередНачаломИзменения(Элемент, Отказ)

	Отказ = Истина;	

КонецПроцедуры
