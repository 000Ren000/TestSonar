﻿
#Область ОбработчикиСобытийФормы
// Код процедур и функций

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Заголовок = Сотрудник;
	Сотрудник          = Параметры.Сотрудник;
	ТекущийСклад       = Параметры.ТекущийСклад;
	ЭтоКонтроль        = Параметры.ЭтоКонтроль;
	ЭтоДоставка        = Параметры.ЭтоДоставка;
	ПоказыватьФотоТоваров = Параметры.ПоказыватьФотоТоваров;
	
	УстановитьУсловноеОформление();
	ЗаполнитьСписокРаспоряжений();
	ЗаполнитьСтатистику();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРаспоряженийНазначенныеМне

&НаКлиенте
Процедура СписокРаспоряженийНазначенныеМнеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элементы.СписокРаспоряжений.ТекущиеДанные;
	
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.СписокРаспоряженийВыбран Тогда
		
	Иначе
		
		Описание = Новый ОписаниеОповещения("ОбновитьДанныеФормы", ЭтаФорма);
		
		ПараметрыОткрытияФормы = Новый Структура;
		ПараметрыОткрытияФормы.Вставить("Распоряжение", ТекущаяСтрока.Распоряжение);
		ПараметрыОткрытияФормы.Вставить("ПоказыватьФотоТоваров", ПоказыватьФотоТоваров);
		
		ОткрытьФорму(
			"Обработка.МобильноеРабочееМестоСборкиИКурьерскойДоставки.Форма.КарточкаРаспоряжения",
			ПараметрыОткрытияФормы,
			ЭтаФорма,,,,Описание,
			РежимОткрытияОкнаФормы.Независимый);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СписокРаспоряженийВыбранПриИзменении(Элемент)
	
	ВыбраноЗаказов = 0;
	
	Для Каждого СтрокаЗаказ Из СписокРаспоряжений Цикл
		
		Если СтрокаЗаказ.Выбран Тогда
			ВыбраноЗаказов = ВыбраноЗаказов + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Элементы.Назначить.Заголовок = НСтр("ru = 'Назначить'") + " " + Строка(ВыбраноЗаказов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назначить(Команда)
	НазначитьСотрудникаНаСервере();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура СнятьСотрудника(Команда)
	РаспоряжениеИзменено = СнятьСотрудникаНаСервере(Элементы.СписокРаспоряжений.ТекущиеДанные.Распоряжение);
	Если РаспоряжениеИзменено Тогда
		ОбновитьДанныеФормы();
	Иначе
		Если ЭтоДоставка Тогда
			ТекстОшибки = НСтр("ru='Не удалось снять курьера.'");
		Иначе
			ТекстОшибки = НСтр("ru='Не удалось снять сборщика.'");
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьФорму(Команда)
	ОбновитьДанныеФормы();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДанныеФормы(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаполнитьСписокРаспоряжений();
	ЗаполнитьСтатистику();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатистику()
	
	Назначено = 0;
	ВПроцессе = 0;
	Готово = 0;
	ДатаПоследнего = Дата('0001,01,01');
	
	Если ЭтоДоставка Тогда
		Запрос = ЗапросДляСтатистикиДоставка();
	Иначе
		Запрос = ЗапросДляСтатистикиСборка();
	КонецЕсли;

	Результаты = Запрос.ВыполнитьПакет();
	
	ВыборкаНазначено = Результаты[0].Выбрать();
	ВыборкаВПроцессе = Результаты[1].Выбрать();
	ВыборкаГотово = Результаты[2].Выгрузить();
	
	Пока ВыборкаНазначено.Следующий() Цикл
		Назначено = ВыборкаНазначено.Назначено;
	КонецЦикла;
	
	Пока ВыборкаВПроцессе.Следующий() Цикл
		ВПроцессе = ВыборкаВПроцессе.ВПроцессе;
	КонецЦикла;
	
	Для Каждого СтрокаВыборкаГотово Из ВыборкаГотово Цикл
		
		ДатаПоследнего = СтрокаВыборкаГотово.Дата;
		Готово = СтрокаВыборкаГотово.Количество;
		
	КонецЦикла;
	
	Элементы.НазначеноКоличество.Заголовок = Назначено;
	Элементы.ВПроцессеКоличество.Заголовок = ВПроцессе;
	Элементы.РаспоряженийЗаконченоКоличество.Заголовок = Готово;
	Если ДатаПоследнего = NULL Тогда
		Элементы.ПоследнийВремя.Заголовок = " нет";
	Иначе
		Элементы.ПоследнийВремя.Заголовок = " в " + Формат(ДатаПоследнего,"ДФ=HH:mm");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокРаспоряжений()
	
	Если ЭтоКонтроль Тогда
		Запрос = ЗапросКонтроль();
	Иначе
		Запрос = ЗапросНазначение();
	КонецЕсли;
	
	Результаты = Запрос.ВыполнитьПакет();
	
	ВыборкаПоРаспоряжениям = Результаты[1].Выбрать();
	
	СписокРаспоряжений.Очистить();
	
	Пока ВыборкаПоРаспоряжениям.Следующий() Цикл
		
		НоваяСтрока = СписокРаспоряжений.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПоРаспоряжениям);
		
		Если ЗначениеЗаполнено(НоваяСтрока.Комментарий) Тогда
			НоваяСтрока.КомментарийКартинка = БиблиотекаКартинок.КомментарийКрасныйДоставка;
		КонецЕсли;
		
		Модуль = Обработки.МобильноеРабочееМестоСборкиИКурьерскойДоставки;
		
		НоваяСтрока.ДатаВремяДоставкиПредставление = Модуль.ДатаВремяДоставкиПредставление(НоваяСтрока);
		НоваяСтрока.ОсталосьВремениНаДоставку = Модуль.ОсталосьВремениНаДоставку(НоваяСтрока);
		НоваяСтрока.СуммаПредставление = Модуль.СуммаПредставление(НоваяСтрока);
		НоваяСтрока.ФормаОплатыПредставление = Модуль.ФормаОплатыПредставление(НоваяСтрока);
		
		НоваяСтрока.КоличествоСтрок = Строка(ВыборкаПоРаспоряжениям.КоличествоСтрокСобрано) + "/" + Строка(ВыборкаПоРаспоряжениям.КоличествоСтрокВЗаказе);
		
	КонецЦикла;
	
	КоличествоРаспоряженийПоСкладу = СписокРаспоряжений.Количество();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	Заголовок = Сотрудник;
	
	Элементы.СписокРаспоряженийСнять.Видимость    = ЭтоКонтроль;
	Элементы.СписокРаспоряженийВыбран.Видимость   = НЕ ЭтоКонтроль;
	Элементы.Назначить.Видимость                  = НЕ ЭтоКонтроль;
	
	Если ЭтоДоставка Тогда
		Элементы.РаспоряженийЗакончено.Заголовок             = НСтр("ru='Доставлено'");
		Элементы.РаспоряженийВПроцессе.Заголовок             = НСтр("ru='Доставляется'");
		Элементы.СписокРаспоряженийСнять.Заголовок           = НСтр("ru='Снять курьера'");
		Элементы.СписокРаспоряженийКоличествоСтрок.Видимость = Ложь;
	Иначе
		Элементы.РаспоряженийЗакончено.Заголовок             = НСтр("ru='Собрано'");
		Элементы.РаспоряженийВПроцессе.Заголовок             = НСтр("ru='Собирается'");
		Элементы.СписокРаспоряженийСнять.Заголовок           = НСтр("ru='Снять сборщика'");
		Элементы.СписокРаспоряженийКоличествоСтрок.Видимость = ЭтоКонтроль;
	КонецЕсли;
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРаспоряженийНазначенныеМнеСтатус.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРаспоряженийНазначенныеМне.Статус");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Перечисления.СтатусыСборкиИДоставки.ГотовКДоставке;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаСтатусаГотовСборкаИДоставка);

	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокРаспоряженийНазначенныеМнеОсталосьВремениНаДоставку.Имя);
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокРаспоряженийНазначенныеМне.Опоздание");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаОтрицательныхЗначений);
	
КонецПроцедуры

&НаСервере
Процедура НазначитьСотрудникаНаСервере()
	
	Для Каждого СтрокаРаспоряжения Из СписокРаспоряжений Цикл
		
		Если СтрокаРаспоряжения.Выбран Тогда
			
			РаспоряжениеОбъект = СтрокаРаспоряжения.Распоряжение.ПолучитьОбъект();
			Если ЭтоДоставка Тогда
				РаспоряжениеОбъект.Курьер = Сотрудник;
			Иначе
				РаспоряжениеОбъект.Сборщик = Сотрудник;
			КонецЕсли;
			РаспоряжениеОбъект.Записать(РежимЗаписиДокумента.Запись);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ЗапросКонтроль()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	СтатусыСборкиИДоставки.Распоряжение КАК Распоряжение,
	|	СтатусыСборкиИДоставки.Статус КАК Статус,
	|	Документы.Склад КАК Склад,
	|	Документы.Сборщик КАК Сборщик,
	|	Документы.Номер КАК Номер,
	|	Документы.ДатаОтгрузки КАК ДатаДоставки,
	|	Документы.ВремяДоставкиС КАК ВремяДоставкиС,
	|	Документы.ВремяДоставкиПо КАК ВремяДоставкиПо,
	|	Документы.СуммаДокумента КАК СуммаДокумента,
	|	0 КАК СуммаКОплате,
	|	Документы.АдресДоставки КАК АдресДоставкиПредставление,
	|	Документы.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	|	Документы.ДополнительнаяИнформацияПоДоставке КАК ДополнительнаяИнформацияПоДоставке,
	|	Документы.Валюта КАК Валюта,
	|	Документы.ФормаОплаты КАК ФормаОплаты,
	|	NULL КАК Дата,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрок,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрокВЗаказе,
	|	СтатусыСборкиИДоставки.КоличествоСтрокСобрано КАК КоличествоСтрокСобрано,
	|	Документы.Комментарий КАК Комментарий
	|ПОМЕСТИТЬ ВсеРаспоряжения
	|ИЗ
	|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК Документы
	|		ПО ((ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.ЗаказКлиента)) = Документы.Ссылка)
	|ГДЕ
	|	СтатусыСборкиИДоставки.Статус В (&Статусы)
	|	И Документы.Проведен
	|	И ВЫБОР
	|		КОГДА &ЭтоДоставка
	|			ТОГДА Документы.Курьер = &Сотрудник
	|		ИНАЧЕ Документы.Сборщик = &Сотрудник
	|	КОНЕЦ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтатусыСборкиИДоставки.Распоряжение,
	|	СтатусыСборкиИДоставки.Статус,
	|	Документы.Склад,
	|	Документы.Сборщик,
	|	Документы.Номер,
	|	NULL,
	|	Документы.ВремяДоставкиС,
	|	Документы.ВремяДоставкиПо,
	|	Документы.СуммаДокумента,
	|	0,
	|	Документы.АдресДоставки,
	|	Документы.АдресДоставкиЗначенияПолей,
	|	Документы.ДополнительнаяИнформацияПоДоставке,
	|	Документы.Валюта,
	|	Документы.ФормаОплаты,
	|	Документы.Дата,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрок,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе,
	|	СтатусыСборкиИДоставки.КоличествоСтрокСобрано,
	|	Документы.Комментарий
	|ИЗ
	|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК Документы
	|		ПО ((ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.РеализацияТоваровУслуг)) = Документы.Ссылка)
	|ГДЕ
	|	СтатусыСборкиИДоставки.Статус В (&Статусы)
	|	И Документы.Проведен
	|	И ВЫБОР
	|		КОГДА &ЭтоДоставка
	|			ТОГДА Документы.Курьер = &Сотрудник
	|		ИНАЧЕ Документы.Сборщик = &Сотрудник
	|	КОНЕЦ
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Распоряжения.Распоряжение КАК Распоряжение,
	|	Распоряжения.Статус КАК Статус,
	|	Распоряжения.Склад КАК Склад,
	|	Распоряжения.Сборщик КАК Сборщик,
	|	Распоряжения.Номер КАК Номер,
	|	Распоряжения.ДатаДоставки КАК ДатаДоставки,
	|	Распоряжения.ВремяДоставкиС КАК ВремяДоставкиС,
	|	Распоряжения.ВремяДоставкиПо КАК ВремяДоставкиПо,
	|	Распоряжения.СуммаДокумента КАК СуммаДокумента,
	|	Распоряжения.СуммаКОплате КАК СуммаКОплате,
	|	Распоряжения.АдресДоставкиПредставление КАК АдресДоставкиПредставление,
	|	Распоряжения.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	|	Распоряжения.ДополнительнаяИнформацияПоДоставке КАК Комментарий,
	|	Распоряжения.Валюта КАК Валюта,
	|	Распоряжения.ФормаОплаты КАК ФормаОплаты,
	|	Распоряжения.Дата КАК Дата,
	|	Распоряжения.КоличествоСтрок КАК КоличествоСтрок,
	|	Распоряжения.КоличествоСтрокВЗаказе КАК КоличествоСтрокВЗаказе,
	|	Распоряжения.КоличествоСтрокСобрано КАК КоличествоСтрокСобрано,
	|	Распоряжения.Комментарий КАК Комментарий1
	|ИЗ
	|	ВсеРаспоряжения КАК Распоряжения
	|ГДЕ
	|	Распоряжения.Склад В ИЕРАРХИИ (&Склад)
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДоставки,
	|	ВремяДоставкиПо";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	Запрос.УстановитьПараметр("ЭтоДоставка", ЭтоДоставка);
	Если ЭтоДоставка Тогда
		Запрос.УстановитьПараметр("Статусы", СкладыСервер.СтатусыРаспоряженийКонтрольДоставки());
	Иначе
		Запрос.УстановитьПараметр("Статусы", СкладыСервер.СтатусыРаспоряженийКонтрольСборки());
	КонецЕсли;

	Возврат Запрос;
	
КонецФункции

&НаСервере
Функция ЗапросНазначение()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	|	СтатусыСборкиИДоставки.Распоряжение КАК Распоряжение,
	|	СтатусыСборкиИДоставки.Статус КАК Статус,
	|	Документы.Склад КАК Склад,
	|	Документы.Сборщик КАК Сборщик,
	|	Документы.Номер КАК Номер,
	|	Документы.ДатаОтгрузки КАК ДатаДоставки,
	|	Документы.ВремяДоставкиС КАК ВремяДоставкиС,
	|	Документы.ВремяДоставкиПо КАК ВремяДоставкиПо,
	|	Документы.СуммаДокумента КАК СуммаДокумента,
	|	0 КАК СуммаКОплате,
	|	Документы.АдресДоставки КАК АдресДоставкиПредставление,
	|	Документы.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	|	Документы.ДополнительнаяИнформацияПоДоставке КАК ДополнительнаяИнформацияПоДоставке,
	|	Документы.Валюта КАК Валюта,
	|	Документы.ФормаОплаты КАК ФормаОплаты,
	|	NULL КАК Дата,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрок,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрокВЗаказе,
	|	СтатусыСборкиИДоставки.КоличествоСтрокСобрано КАК КоличествоСтрокСобрано
	|ПОМЕСТИТЬ ВсеРаспоряжения
	|ИЗ
	|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ЗаказКлиента КАК Документы
	|		ПО ((ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.ЗаказКлиента)) = Документы.Ссылка)
	|ГДЕ
	|	СтатусыСборкиИДоставки.Статус В (&Статусы)
	|	И ВЫБОР
	|		КОГДА &ЭтоДоставка
	|			ТОГДА Документы.Курьер = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ Документы.Сборщик = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	КОНЕЦ
	|	И Документы.Проведен
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	СтатусыСборкиИДоставки.Распоряжение,
	|	СтатусыСборкиИДоставки.Статус,
	|	Документы.Склад,
	|	Документы.Сборщик,
	|	Документы.Номер,
	|	NULL,
	|	Документы.ВремяДоставкиС,
	|	Документы.ВремяДоставкиПо,
	|	Документы.СуммаДокумента,
	|	0,
	|	Документы.АдресДоставки,
	|	Документы.АдресДоставкиЗначенияПолей,
	|	Документы.ДополнительнаяИнформацияПоДоставке,
	|	Документы.Валюта,
	|	Документы.ФормаОплаты,
	|	Документы.Дата,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе КАК КоличествоСтрок,
	|	СтатусыСборкиИДоставки.КоличествоСтрокВЗаказе,
	|	СтатусыСборкиИДоставки.КоличествоСтрокСобрано
	|ИЗ
	|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК Документы
	|		ПО ((ВЫРАЗИТЬ(СтатусыСборкиИДоставки.Распоряжение КАК Документ.РеализацияТоваровУслуг)) = Документы.Ссылка)
	|ГДЕ
	|	СтатусыСборкиИДоставки.Статус В (&Статусы)
	|	И ВЫБОР
	|		КОГДА &ЭтоДоставка
	|			ТОГДА Документы.Курьер = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|		ИНАЧЕ Документы.Сборщик = ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)
	|	КОНЕЦ
	|	И Документы.Проведен
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Распоряжения.Распоряжение КАК Распоряжение,
	|	Распоряжения.Статус КАК Статус,
	|	Распоряжения.Склад КАК Склад,
	|	Распоряжения.Сборщик КАК Сборщик,
	|	Распоряжения.Номер КАК Номер,
	|	Распоряжения.ДатаДоставки КАК ДатаДоставки,
	|	Распоряжения.ВремяДоставкиС КАК ВремяДоставкиС,
	|	Распоряжения.ВремяДоставкиПо КАК ВремяДоставкиПо,
	|	Распоряжения.СуммаДокумента КАК СуммаДокумента,
	|	Распоряжения.СуммаКОплате КАК СуммаКОплате,
	|	Распоряжения.АдресДоставкиПредставление КАК АдресДоставкиПредставление,
	|	Распоряжения.АдресДоставкиЗначенияПолей КАК АдресДоставкиЗначенияПолей,
	|	Распоряжения.ДополнительнаяИнформацияПоДоставке КАК Комментарий,
	|	Распоряжения.Валюта КАК Валюта,
	|	Распоряжения.ФормаОплаты КАК ФормаОплаты,
	|	Распоряжения.Дата КАК Дата,
	|	Распоряжения.КоличествоСтрок КАК КоличествоСтрок,
	|	Распоряжения.КоличествоСтрокВЗаказе КАК КоличествоСтрокВЗаказе,
	|	Распоряжения.КоличествоСтрокСобрано КАК КоличествоСтрокСобрано
	|ИЗ
	|	ВсеРаспоряжения КАК Распоряжения
	|ГДЕ
	|	Распоряжения.Склад В ИЕРАРХИИ (&Склад)
	|УПОРЯДОЧИТЬ ПО
	|	ДатаДоставки,
	|	ВремяДоставкиПо";
	
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	Запрос.УстановитьПараметр("ЭтоДоставка", ЭтоДоставка);
	
	Статусы = Новый Массив;
	
	Если ЭтоДоставка Тогда
		Статусы = СкладыСервер.СтатусыРаспоряженийДляНачалаДоставкиКурьером();
	Иначе
		Статусы.Добавить(Перечисления.СтатусыСборкиИДоставки.КСборке);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Статусы", Статусы);
	
	Возврат Запрос;
	
КонецФункции

&НаСервере
Функция СнятьСотрудникаНаСервере(Распоряжение)
	
	СтатусРаспоряжения = СтатусРаспоряжения(Распоряжение);
	Если СтатусРаспоряжения = Перечисления.СтатусыСборкиИДоставки.КСборке И НЕ ЭтоДоставка Тогда
		
		РаспоряжениеОбъект = Распоряжение.ПолучитьОбъект();
		РаспоряжениеОбъект.Сборщик = Справочники.ФизическиеЛица.ПустаяСсылка();
		РаспоряжениеОбъект.Записать(РежимЗаписиДокумента.Запись);
		
		Возврат Истина;
		
	ИначеЕсли (СтатусРаспоряжения = Перечисления.СтатусыСборкиИДоставки.ГотовКДоставке
		ИЛИ СтатусРаспоряжения = Перечисления.СтатусыСборкиИДоставки.КСборке
		ИЛИ СтатусРаспоряжения = Перечисления.СтатусыСборкиИДоставки.Обрабатывается
		ИЛИ СтатусРаспоряжения = Перечисления.СтатусыСборкиИДоставки.Собирается
		ИЛИ СтатусРаспоряжения = Перечисления.СтатусыСборкиИДоставки.Собран) 
		И ЭтоДоставка Тогда
		
		РаспоряжениеОбъект = Распоряжение.ПолучитьОбъект();
		РаспоряжениеОбъект.Курьер = Справочники.ФизическиеЛица.ПустаяСсылка();
		РаспоряжениеОбъект.Записать(РежимЗаписиДокумента.Запись);
		
		Возврат Истина;
		
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция СтатусРаспоряжения(Распоряжение)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СтатусыСборкиИДоставки.Статус КАК Статус
		|ИЗ
		|	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
		|ГДЕ
		|	СтатусыСборкиИДоставки.Распоряжение = &Распоряжение";
	
	Запрос.УстановитьПараметр("Распоряжение", Распоряжение);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.Статус;
	КонецЦикла;
	
	Возврат Перечисления.СтатусыСборкиИДоставки.КСборке;
	
КонецФункции

&НаСервере
Функция ЗапросДляСтатистикиСборка()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СтатусыСборкиИДоставки.Статус КАК Статус,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтатусыСборкиИДоставки.Распоряжение) КАК Назначено
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Распоряжение.Сборщик = &Сотрудник
	               |	И СтатусыСборкиИДоставки.Статус = &КСборке
	               |	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ СтатусыСборкиИДоставки.Распоряжение.Склад В ИЕРАРХИИ (&Склад))
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СтатусыСборкиИДоставки.Статус
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СтатусыСборкиИДоставки.Статус КАК Статус,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтатусыСборкиИДоставки.Распоряжение) КАК ВПроцессе
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Распоряжение.Сборщик = &Сотрудник
	               |	И СтатусыСборкиИДоставки.Статус = &Собирается
	               |	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ СтатусыСборкиИДоставки.Распоряжение.Склад В ИЕРАРХИИ (&Склад))
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СтатусыСборкиИДоставки.Статус
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МАКСИМУМ(ЕСТЬNULL(СтатусыСборкиИДоставки.ДатаСборки, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))) КАК Дата,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтатусыСборкиИДоставки.Распоряжение) КАК Количество
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Распоряжение.Сборщик = &Сотрудник
	               |	И СтатусыСборкиИДоставки.ДатаСборки МЕЖДУ &НачалоПериода И &КонецПериода
	               |	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ СтатусыСборкиИДоставки.Распоряжение.Склад В ИЕРАРХИИ (&Склад))";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ТекущаяДатаСеанса()));
	
	Запрос.УстановитьПараметр("КСборке", Перечисления.СтатусыСборкиИДоставки.КСборке);
	Запрос.УстановитьПараметр("Собирается", Перечисления.СтатусыСборкиИДоставки.Собирается);
	
	Возврат Запрос;
	
КонецФункции

&НаСервере
Функция ЗапросДляСтатистикиДоставка()
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ
	               |	СтатусыСборкиИДоставки.Статус КАК Статус,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтатусыСборкиИДоставки.Распоряжение) КАК Назначено
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Распоряжение.Сборщик = &Сотрудник
	               |	И СтатусыСборкиИДоставки.Статус В(&Назначено)
	               |	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ СтатусыСборкиИДоставки.Распоряжение.Склад В ИЕРАРХИИ (&Склад))
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СтатусыСборкиИДоставки.Статус
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	СтатусыСборкиИДоставки.Статус КАК Статус,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтатусыСборкиИДоставки.Распоряжение) КАК ВПроцессе
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Распоряжение.Сборщик = &Сотрудник
	               |	И СтатусыСборкиИДоставки.Статус = &Доставляется
	               |	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ СтатусыСборкиИДоставки.Распоряжение.Склад В ИЕРАРХИИ (&Склад))
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	СтатусыСборкиИДоставки.Статус
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	МАКСИМУМ(ЕСТЬNULL(СтатусыСборкиИДоставки.ДатаДоставки, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0))) КАК Дата,
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СтатусыСборкиИДоставки.Распоряжение) КАК Количество
	               |ИЗ
	               |	РегистрСведений.СтатусыСборкиИДоставки КАК СтатусыСборкиИДоставки
	               |ГДЕ
	               |	СтатусыСборкиИДоставки.Распоряжение.Сборщик = &Сотрудник
	               |	И СтатусыСборкиИДоставки.ДатаДоставки МЕЖДУ &НачалоПериода И &КонецПериода
	               |	И (&Склад = ЗНАЧЕНИЕ(Справочник.Склады.ПустаяСсылка)
	               |			ИЛИ СтатусыСборкиИДоставки.Распоряжение.Склад В ИЕРАРХИИ (&Склад))";
	
	Запрос.УстановитьПараметр("Сотрудник", Сотрудник);
	Запрос.УстановитьПараметр("Склад", ТекущийСклад);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоДня(ТекущаяДатаСеанса()));
	Запрос.УстановитьПараметр("КонецПериода", КонецДня(ТекущаяДатаСеанса()));
	
	СтатусыНазначено = Новый Массив;
	СтатусыНазначено.Добавить(Перечисления.СтатусыСборкиИДоставки.ГотовКДоставке);
	СтатусыНазначено.Добавить(Перечисления.СтатусыСборкиИДоставки.КСборке);
	СтатусыНазначено.Добавить(Перечисления.СтатусыСборкиИДоставки.Обрабатывается);
	СтатусыНазначено.Добавить(Перечисления.СтатусыСборкиИДоставки.Собирается);
	СтатусыНазначено.Добавить(Перечисления.СтатусыСборкиИДоставки.Собран);
	
	Запрос.УстановитьПараметр("Назначено", СтатусыНазначено);
	Запрос.УстановитьПараметр("Доставляется", Перечисления.СтатусыСборкиИДоставки.Доставляется);
	
	Возврат Запрос;
	
КонецФункции

#КонецОбласти
