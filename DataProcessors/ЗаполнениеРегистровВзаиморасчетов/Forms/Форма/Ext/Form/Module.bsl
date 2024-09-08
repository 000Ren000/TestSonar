﻿
#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоУказанным(Команда)
	ТекстВопроса = СтрШаблон(НСтр("ru = 'По данным первичных движений будут перезаполнены регистры: %1
	|
	|Задания к переотражению в БУ, МФУ, НДС и к закрытию месяца созданы не будут. Продолжить?'"),
		ИменаРегистров());
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоУказаннымЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоУказаннымЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Сообщить(НСтр("ru = 'Начало операции:'") + " " + ТекущаяДата());
		ЗаполнитьПоУказаннымНаСервере();
		Сообщить(НСтр("ru = 'Операция выполнена успешно:'") + " " + ТекущаяДата());
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ОчиститьСообщения();
	Сообщить(НСтр("ru = 'Начало операции:'") + " " + ТекущаяДата());
	ОчиститьНаСервере();
	Сообщить(НСтр("ru = 'Операция выполнена успешно:'") + " " + ТекущаяДата());
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВсё(Команда)
	ТекстВопроса = СтрШаблон(НСтр("ru = 'По данным первичных движений будут перезаполнены регистры: %1
	|
	|Задания к переотражению в БУ, МФУ, НДС и к закрытию месяца созданы не будут. Продолжить?'"),
		ИменаРегистров());
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьВсёЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВсёЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Сообщить(НСтр("ru = 'Начало операции:'") + " " + ТекущаяДата());
		ЗаполнитьВсёСервер();
		Сообщить(НСтр("ru = 'Операция выполнена успешно:'") + " " + ТекущаяДата());
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПлановые(Команда)
	ТекстВопроса = СтрШаблон(НСтр("ru = 'По данным первичных движений будут перезаполнены регистры: %1
	|
	|Продолжить?'"),
		ИменаРегистров(Истина));
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПлановыеЗавершение", ЭтотОбъект), ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПлановыеЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьПлановыеНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьПоУказаннымНаСервере(Порядок = "")
	
	Если Не ЗначениеЗаполнено(КлючАналитикиУчетаПоПартнерам) Тогда
		ТекстИсключения = НСтр("ru = 'Для частичного заполнения укажите Ключ аналитики учета по партнерам.'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("АналитикаУчетаПоПартнерам",КлючАналитикиУчетаПоПартнерам);
	Запрос.УстановитьПараметр("ОбъектРасчетов",ОбъектРасчетов);
	
	Если ЗначениеЗаполнено(ОбъектРасчетов) И ЗначениеЗаполнено(КлючАналитикиУчетаПоПартнерам) Тогда
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Истина                 КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
		|ГДЕ
		|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
		|	И Расчеты.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Ложь                   КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
		|ГДЕ
		|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
		|	И Расчеты.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Истина                   КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Расчеты
		|ГДЕ
		|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
		|	И Расчеты.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Ложь                   КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам КАК Расчеты
		|ГДЕ
		|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
		|	И Расчеты.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам";
		
		ТаблицаОбъектов = Запрос.Выполнить().Выгрузить();
		
	ИначеЕсли ЗначениеЗаполнено(ОбъектРасчетов) Тогда
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Истина                 КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
		|ГДЕ
		|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Ложь                   КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
		|ГДЕ
		|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Истина                   КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Расчеты
		|ГДЕ
		|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Ложь                   КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам КАК Расчеты
		|ГДЕ
		|	Расчеты.ОбъектРасчетов = &ОбъектРасчетов";
		
		ТаблицаОбъектов = Запрос.Выполнить().Выгрузить();
		
	Иначе
		
		Запрос.Текст = "
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Истина                 КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентами КАК Расчеты
		|ГДЕ
		|	Расчеты.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Ложь                   КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщиками КАК Расчеты
		|ГДЕ
		|	Расчеты.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Истина                 КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам КАК Расчеты
		|ГДЕ
		|	Расчеты.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Расчеты.АналитикаУчетаПоПартнерам КАК АналитикаУчетаПоПартнерам,
		|	Расчеты.ОбъектРасчетов КАК ОбъектРасчетов,
		|	Расчеты.Валюта         КАК ВалютаРасчетов,
		|	Ложь                   КАК ЭтоРасчетыСКлиентами
		|ИЗ
		|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Расчеты
		|ГДЕ
		|	Расчеты.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам";
		
		ТаблицаОбъектов = Запрос.Выполнить().Выгрузить();
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаНачалаПересчета) Тогда
		ОперативныеВзаиморасчетыСервер.ОчиститьРегистрыВзаиморасчетовИУдалитьСлужебныеРегистраторы(?(ЗначениеЗаполнено(
			ОбъектРасчетов), ОбъектРасчетов, Неопределено), ?(ЗначениеЗаполнено(КлючАналитикиУчетаПоПартнерам),
			КлючАналитикиУчетаПоПартнерам, Неопределено));
	КонецЕсли;
	
	Для Каждого СтрокаТаблицы Из ТаблицаОбъектов Цикл
		
		ОсновныеПараметры = ОперативныеВзаиморасчетыСервер.СтруктураПараметровЗаполненияВзаиморасчетов();
		ЗаполнитьЗначенияСвойств(ОсновныеПараметры,СтрокаТаблицы);
		Если ЗначениеЗаполнено(ДатаНачалаПересчета) Тогда
			ОсновныеПараметры.ПорядокФакт = ОперативныеВзаиморасчетыСервер.Порядок(ДатаНачалаПересчета,"",,Тип("ДокументСсылка.РегистраторРасчетов"));
			ОсновныеПараметры.ПорядокПлан = ОперативныеВзаиморасчетыСервер.Порядок(ДатаНачалаПересчета,"",,Тип("ДокументСсылка.РегистраторРасчетов"));
		КонецЕсли;
		
		Если СтрокаТаблицы.ЭтоРасчетыСКлиентами Тогда
		
			Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Регистр.Регистратор КАК Регистратор
			|ИЗ
			|	РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК Регистр
			|ГДЕ
			|	Регистр.Регистратор ССЫЛКА Документ.КорректировкаРегистров
			|	И ВЫРАЗИТЬ(Регистр.Регистратор КАК Документ.КорректировкаРегистров).Операция <> ЗНАЧЕНИЕ(Перечисление.ОперацииКорректировкиРегистров.РучнаяКорректировка)
			|	И Регистр.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам
			|	И Регистр.ОбъектРасчетов = &ОбъектРасчетов
			|";
			Запрос.УстановитьПараметр("ОбъектРасчетов",ОбъектРасчетов);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ДокументОбъект = Выборка.Регистратор.ПолучитьОбъект();
				ДвиженияРасчетыСКлиентами = ДокументОбъект.Движения.РасчетыСКлиентамиПоСрокам;
				ДвиженияРасчетыСКлиентами.Прочитать();
				сч = 0;
				Пока сч < ДвиженияРасчетыСКлиентами.Количество() Цикл
					Если ДвиженияРасчетыСКлиентами[сч].АналитикаУчетаПоПартнерам = КлючАналитикиУчетаПоПартнерам
						И ДвиженияРасчетыСКлиентами[сч].ОбъектРасчетов = ОбъектРасчетов Тогда
						ДвиженияРасчетыСКлиентами.Удалить(сч);
					Иначе
						сч = сч + 1;
					КонецЕсли;
				КонецЦикла;
				ДвиженияРасчетыСКлиентами.Записать();
			КонецЦикла;
		Иначе
			
			Запрос.Текст = "
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	Регистр.Регистратор КАК Регистратор
			|ИЗ
			|	РегистрНакопления.РасчетыСПоставщикамиПоСрокам КАК Регистр
			|ГДЕ
			|	Регистр.Регистратор ССЫЛКА Документ.КорректировкаРегистров
			|	И ВЫРАЗИТЬ(Регистр.Регистратор КАК Документ.КорректировкаРегистров).Операция <> ЗНАЧЕНИЕ(Перечисление.ОперацииКорректировкиРегистров.РучнаяКорректировка)
			|	И Регистр.АналитикаУчетаПоПартнерам = &АналитикаУчетаПоПартнерам
			|	И Регистр.ОбъектРасчетов = &ОбъектРасчетов
			|";
			Запрос.УстановитьПараметр("ОбъектРасчетов",ОбъектРасчетов);
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				ДокументОбъект = Выборка.Регистратор.ПолучитьОбъект();
				
				ДвиженияРасчетыСПоставщиками = ДокументОбъект.Движения.РасчетыСПоставщикамиПоСрокам;
				ДвиженияРасчетыСПоставщиками.Прочитать();
				сч = 0;
				Пока сч < ДвиженияРасчетыСПоставщиками.Количество() Цикл
					Если ДвиженияРасчетыСПоставщиками[сч].АналитикаУчетаПоПартнерам = КлючАналитикиУчетаПоПартнерам
						И ДвиженияРасчетыСПоставщиками[сч].ОбъектРасчетов = ОбъектРасчетов Тогда
						ДвиженияРасчетыСПоставщиками.Удалить(сч);
					Иначе
						сч = сч + 1;
					КонецЕсли;
				КонецЦикла;
				ДвиженияРасчетыСПоставщиками.Записать();
				
			КонецЦикла;
			
		КонецЕсли;
		
		ОсновныеПараметры.ЭтоРасчетыСКлиентами = СтрокаТаблицы.ЭтоРасчетыСКлиентами;
		ОперативныеВзаиморасчетыСервер.ЗаполнитьОперативныеВзаиморасчеты(ОсновныеПараметры);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьНаСервере()
	ОперативныеВзаиморасчетыСервер.ОчиститьРегистрыВзаиморасчетов();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВсёСервер()
	ОперативныеВзаиморасчетыСервер.ЗаполнитьПоВсемРасчетам();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПлановыеНаСервере()
	
	ОперативныеВзаиморасчетыСервер.ОчиститьРегистр("РасчетыСКлиентамиПланОплат");
	ОперативныеВзаиморасчетыСервер.ОчиститьРегистр("РасчетыСКлиентамиПланОтгрузок");
	ОперативныеВзаиморасчетыСервер.ОчиститьРегистр("РасчетыСПоставщикамиПланОплат");
	ОперативныеВзаиморасчетыСервер.ОчиститьРегистр("РасчетыСПоставщикамиПланПоставок");
	
	ОперативныеВзаиморасчетыСервер.ЗаполнитьПлановыеРасчеты(Неопределено,Неопределено);
	
КонецПроцедуры

&НаСервере
Функция ИменаРегистров(ТолькоПлановые = Ложь)
	Если НЕ ТолькоПлановые Тогда
		Возврат 
			СтрШаблон("
			|	%1
			|	%2
			|	%3
			|	%4
			|	%5
			|	%6",
			Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.Синоним,
			Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат.Синоним,
			Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок.Синоним,
			Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоСрокам.Синоним,
			Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланОплат.Синоним,
			Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.Синоним
			);
	Иначе
		Возврат 
			СтрШаблон("
			|	%1
			|	%2
			|	%3
			|	%4",
			Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат.Синоним,
			Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок.Синоним,
			Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланОплат.Синоним,
			Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.Синоним
			);
	КонецЕсли;
КонецФункции

#КонецОбласти

