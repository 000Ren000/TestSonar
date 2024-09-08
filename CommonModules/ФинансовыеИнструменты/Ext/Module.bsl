﻿
#Область ПрограммныйИнтерфейс

// Вычисляет приблизительную годовую ставку IRR для графика платежей с произвольной периодичностью. Соответствует функции Excel ЧИСТВНДОХ.
// Вычисление производится методом Ньютона.
// IRR - внутренняя норма доходности, при которой инвестиции равны приведенной стоимости будущих поступлений, т.е. NPV = 0.
//
// Параметры:
//    Платежи - Массив из Число - Суммы платежей по графику. По крайней мере один платеж в графике должен быть положительный и один отрицательный.
//    Даты - Массив из Дата - Даты платежей. Индексы дат в массиве должны совпадать с соответствующими индексами сумм в массиве платежей.
//    Предположение - Число - Предполагаемая ставка (задается в виде числа: например, 0.25 соответствует 25%).
//                            Необязательный параметр, по умолчанию исходная ставка = 0.1.
//
// Возвращаемое значение:
//    Число, Неопределено - Ставка IRR. Если рассчитать ставку не удалось или входные данные некорректны, возвращается Неопределено.
//
Функция ЧИСТВНДОХ(Платежи, Даты, Предположение = Неопределено) Экспорт
	
	Если Предположение = Неопределено Тогда
		Х0 = 0.1;
	Иначе
		Х0 = Предположение;
	КонецЕсли;
	
	ПреобразоватьВходящиеПараметрыЧИСТВНДОХ(Платежи, Даты);
	
	Если Не ПроверитьВходящиеПараметрыЧИСТВНДОХ(Платежи) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Сроки = Новый Массив;
	Для Инд = 0 По Даты.Количество() - 1 Цикл
		Сроки.Добавить((Даты[0] - Даты[Инд]) / 31536000); // В днях
	КонецЦикла;
	
	Х1 = 0.0;
	Допуск = 0.00000001;
	
	МаксИтераций = 500;
	ЧислоИтераций = 0;
	
	Пока ЧислоИтераций < МаксИтераций Цикл
		
		Знаменатель = Всего_ДФ_XIRR(Платежи, Сроки, Х0);
		Если Знаменатель = 0 Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Х1 = Х0 - Всего_Ф_XIRR(Платежи, Сроки, Х0) / Знаменатель;
		Ошибка = МодульЧисла(Х1 - Х0);
		Х0 = Х1;
		
		Если Ошибка <= Допуск Тогда
			Возврат Х0;
		КонецЕсли;
		
		ЧислоИтераций = ЧислоИтераций + 1;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

// Вычисляет значение NPV для графика платежей с одинаковой периодичностью. Соответствует функции Excel ЧПС.
// Платежи не должны включать первоначальную инвестицию, она вычитается из результата.
// Чистая приведенная стоимость (NPV) - сумма дисконтированных потоков платежей, приведенных к начальной дате.
//
// Параметры:
//    Ставка - Число - Ставка дисконтирования (задается в виде числа: например, 0.25 соответствует 25%).
//    Платежи - Массив из Число - Суммы платежей по графику.
//
// Возвращаемое значение:
//    Число - Значение NPV.
//
Функция ЧПС(Ставка, Платежи) Экспорт
	
	Рез = 0;
	
	Для НомерПериода = 0 По Платежи.Количество()-1 Цикл
		Рез = Рез + ПриведенныйПлатежNPV(Ставка, Платежи[НомерПериода], НомерПериода+1);
	КонецЦикла;
	
	Возврат Рез;
	
КонецФункции

// Вычисляет значение NPV для графика платежей с произвольной периодичностью. Соответствует функции Excel ЧИСТНЗ.
// Платежи должны включать первоначальную инвестицию.
// Чистая приведенная стоимость (NPV) - сумма дисконтированных потоков платежей, приведенных к начальной дате.
//
// Параметры:
//    Ставка - Число - Ставка дисконтирования (задается в виде числа: например, 0.25 соответствует 25%).
//    Платежи - Массив из Число - Суммы платежей по графику.
//    Даты - Массив из Дата - Даты платежей. Индексы дат в массиве должны совпадать с соответствующими индексами сумм в массиве платежей.
//
// Возвращаемое значение:
//    Число - Значение NPV.
//
Функция ЧИСТНЗ(Ставка, Платежи, Даты) Экспорт
	
	Рез = 0;
	
	Сроки = Новый Массив;
	Для Инд = 0 По Даты.Количество() - 1 Цикл
		Сроки.Добавить((Даты[Инд] - Даты[0]) / 31536000); // В днях
	КонецЦикла;
	
	Для НомерПериода = 0 По Платежи.Количество()-1 Цикл
		Рез = Рез + ПриведенныйПлатежXNPV(Ставка, Платежи[НомерПериода], Сроки[НомерПериода]);
	КонецЦикла;
	
	Возврат Рез;
	
КонецФункции

// Формирует таблицу для пересчета сумму в валюты упр. и регл. учета. 
// 
// Параметры:
// 	ТекстыЗапроса - СписокЗначений - 
// 	ИмяТаблицы - Строка - 
// 	НесколькоОрганизаций - Булево - признак получения таблиц запросов для пересчета в валюту для нескольких организаций
//
Процедура ТекстЗапросаВтКоэффициентыПересчетаВалют(
			ТекстыЗапроса,
			ИмяТаблицы = "ВтКоэффициентыПересчетаВалют",
			НесколькоОрганизаций = Ложь) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаПериодов.ВалютаВзаиморасчетов,
	|	ТаблицаПериодов.Дата,
	|	&ПоляОрганизаций,
	|	МАКСИМУМ(КурсыВалют.Период) КАК ДатаКурса
	|ПОМЕСТИТЬ ТаблицаПериодовВзаиморасчетов
	|ИЗ
	|	ТаблицаПериодов
	|	,&ТаблицаОрганизаций
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалют
	|	ПО
	|		КурсыВалют.Валюта = ТаблицаПериодов.ВалютаВзаиморасчетов
	|		И КурсыВалют.Период <= ТаблицаПериодов.Дата
	|		И &УсловиеБазовойВалюты
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПериодов.ВалютаВзаиморасчетов,
	|	&ГруппировкаОрганизаций,
	|	ТаблицаПериодов.Дата
	|";
	
	КорректировкаПодзапросаПересчетаВалютПоОрганизации(ТекстЗапроса, "ТаблицаПериодовВзаиморасчетов", НесколькоОрганизаций);
	ТекстыЗапроса.Добавить(ТекстЗапроса, "ТаблицаПериодовВзаиморасчетов");
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаПериодов.ВалютаВзаиморасчетов,
	|	ТаблицаПериодов.Дата,
	|	&ПоляОрганизаций,
	|	МАКСИМУМ(КурсыВалют.Период) КАК ДатаКурса
	|ПОМЕСТИТЬ ТаблицаПериодовУпр
	|ИЗ
	|	ТаблицаПериодов
	|	,&ТаблицаОрганизаций
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалют
	|	ПО
	|		КурсыВалют.Валюта = &ВалютаУпр
	|		И КурсыВалют.Период <= ТаблицаПериодов.Дата
	|		И &УсловиеБазовойВалюты
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПериодов.ВалютаВзаиморасчетов,
	|	&ГруппировкаОрганизаций,
	|	ТаблицаПериодов.Дата
	|";
	
	КорректировкаПодзапросаПересчетаВалютПоОрганизации(ТекстЗапроса, "ТаблицаПериодовУпр", НесколькоОрганизаций);
	ТекстыЗапроса.Добавить(ТекстЗапроса, "ТаблицаПериодовУпр");
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаПериодов.ВалютаВзаиморасчетов,
	|	ТаблицаПериодов.Дата,
	|	&ПоляОрганизаций,
	|	МАКСИМУМ(КурсыВалют.Период) КАК ДатаКурса
	|ПОМЕСТИТЬ ТаблицаПериодовРегл
	|ИЗ
	|	ТаблицаПериодов
	|	,&ТаблицаОрганизаций
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалют
	|	ПО
	|		&УсловиеВалюты
	|		И КурсыВалют.Период <= ТаблицаПериодов.Дата
	|		И &УсловиеБазовойВалюты
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаПериодов.ВалютаВзаиморасчетов,
	|	&ГруппировкаОрганизаций,
	|	ТаблицаПериодов.Дата
	|";
	
	КорректировкаПодзапросаПересчетаВалютПоОрганизации(ТекстЗапроса, "ТаблицаПериодовРегл", НесколькоОрганизаций);
	ТекстыЗапроса.Добавить(ТекстЗапроса, "ТаблицаПериодовРегл");
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	ТаблицаПериодов.ВалютаВзаиморасчетов,
	|	ТаблицаПериодов.Дата,
	|	&ПоляОрганизаций,
	|	КурсыВалют.КурсЧислитель КАК КурсЧислитель,
	|	КурсыВалют.КурсЗнаменатель КАК КурсЗнаменатель,
	|	КурсыВалютУпр.КурсЧислитель КАК КурсЧислительУпр,
	|	КурсыВалютУпр.КурсЗнаменатель КАК КурсЗнаменательУпр,
	|	ВЫБОР
	|		КОГДА КурсыВалют.КурсЗнаменатель <> 0 И КурсыВалютУпр.КурсЧислитель <> 0 ТОГДА
	|			КурсыВалют.КурсЧислитель * КурсыВалютУпр.КурсЗнаменатель / (КурсыВалют.КурсЗнаменатель * КурсыВалютУпр.КурсЧислитель)
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ КАК КоэффициентПересчетаУпр,
	|	ВЫБОР
	|		КОГДА КурсыВалют.КурсЗнаменатель <> 0 И КурсыВалютРегл.КурсЧислитель <> 0 ТОГДА
	|			КурсыВалют.КурсЧислитель * КурсыВалютРегл.КурсЗнаменатель / (КурсыВалют.КурсЗнаменатель * КурсыВалютРегл.КурсЧислитель)
	|		ИНАЧЕ
	|			0
	|	КОНЕЦ КАК КоэффициентПересчетаРегл
	|ПОМЕСТИТЬ ВтКоэффициентыПересчетаВалют
	|ИЗ
	|	ТаблицаПериодов
	|	
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаПериодовВзаиморасчетов
	|	ПО
	|		ТаблицаПериодовВзаиморасчетов.Дата = ТаблицаПериодов.Дата
	|		И ТаблицаПериодовВзаиморасчетов.ВалютаВзаиморасчетов = ТаблицаПериодов.ВалютаВзаиморасчетов
	|		И &УсловиеОрганизацииПоТаблицеПериодовВзаиморасчетов
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалют
	|	ПО
	|		КурсыВалют.Период = ТаблицаПериодовВзаиморасчетов.ДатаКурса
	|		И КурсыВалют.Валюта = ТаблицаПериодовВзаиморасчетов.ВалютаВзаиморасчетов
	|		И &УсловиеБазовойВалютыПоТаблицеПериодовВзаиморасчетов
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаПериодовУпр
	|	ПО
	|		ТаблицаПериодовУпр.Дата = ТаблицаПериодов.Дата
	|		И ТаблицаПериодовУпр.ВалютаВзаиморасчетов = ТаблицаПериодов.ВалютаВзаиморасчетов
	|		И &УсловиеОрганизацииПоТаблицеПериодовУпр
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалютУпр
	|	ПО
	|		КурсыВалютУпр.Период = ТаблицаПериодовУпр.ДатаКурса
	|		И КурсыВалютУпр.Валюта = &ВалютаУпр
	|		И &УсловиеБазовойВалютыПоТаблицеПериодовУпр
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		ТаблицаПериодовРегл
	|	ПО
	|		ТаблицаПериодовРегл.Дата = ТаблицаПериодов.Дата
	|		И ТаблицаПериодовРегл.ВалютаВзаиморасчетов = ТаблицаПериодов.ВалютаВзаиморасчетов
	|		И &УсловиеОрганизацииПоТаблицеПериодовРегл
	|		
	|	ЛЕВОЕ СОЕДИНЕНИЕ
	|		РегистрСведений.ОтносительныеКурсыВалют КАК КурсыВалютРегл
	|	ПО
	|		КурсыВалютРегл.Период = ТаблицаПериодовРегл.ДатаКурса
	|		И &УсловиеВалютыПоТаблицеПериодовРегл
	|ИНДЕКСИРОВАТЬ ПО
	|	ТаблицаПериодов.ВалютаВзаиморасчетов,
	|	&ГруппировкаОрганизаций,
	|	ТаблицаПериодов.Дата
	|";
	
	Если НесколькоОрганизаций Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляОрганизаций", "
							|	ТаблицаПериодов.Организация");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОрганизацииПоТаблицеПериодовВзаиморасчетов",
							"ТаблицаПериодов.Организация = ТаблицаПериодовВзаиморасчетов.Организация");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеБазовойВалютыПоТаблицеПериодовВзаиморасчетов",
							"КурсыВалют.БазоваяВалюта = ТаблицаПериодовВзаиморасчетов.ВалютаРегл");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОрганизацииПоТаблицеПериодовУпр",
							"ТаблицаПериодов.Организация = ТаблицаПериодовУпр.Организация");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеБазовойВалютыПоТаблицеПериодовУпр",
							"КурсыВалютУпр.БазоваяВалюта = ТаблицаПериодовУпр.ВалютаРегл");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОрганизацииПоТаблицеПериодовРегл",
							"ТаблицаПериодов.Организация = ТаблицаПериодовРегл.Организация");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеВалютыПоТаблицеПериодовРегл",
							"КурсыВалютРегл.Валюта = ТаблицаПериодовРегл.ВалютаРегл
							|		И КурсыВалютРегл.БазоваяВалюта = ТаблицаПериодовРегл.ВалютаРегл");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ГруппировкаОрганизаций", "
							|	ТаблицаПериодов.Организация");
		
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляОрганизаций,", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОрганизацииПоТаблицеПериодовВзаиморасчетов", "ИСТИНА");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеБазовойВалютыПоТаблицеПериодовВзаиморасчетов",
							"КурсыВалют.БазоваяВалюта = &ВалютаРегл");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОрганизацииПоТаблицеПериодовУпр", "ИСТИНА");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеБазовойВалютыПоТаблицеПериодовУпр",
							"КурсыВалютУпр.БазоваяВалюта = &ВалютаРегл");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеОрганизацииПоТаблицеПериодовРегл", "ИСТИНА");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеВалютыПоТаблицеПериодовРегл",
							"КурсыВалютРегл.Валюта = &ВалютаРегл
							|		И КурсыВалютРегл.БазоваяВалюта = &ВалютаРегл");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ГруппировкаОрганизаций,", "");
		
	КонецЕсли;
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяТаблицы);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиЭтаповЗакрытияМесяца

#Область НачисленияПоКредитамДепозитамИВыданнымЗаймам

// Добавляет этап в таблицу этапов закрытия месяца.
// Элементы данной таблицы являются элементами второго уровня в дереве этапов в форме закрытия месяца.
// 
// Параметры:
// 	ТаблицаЭтапов - (См. Обработки.ОперацииЗакрытияМесяца.ЗаполнитьОписаниеЭтаповЗакрытияМесяца)
// 	ТекущийРодитель - Строка - идентификатор группы.
Процедура ДобавитьЭтап_НачисленияПоКредитамДепозитамИВыданнымЗаймам(ТаблицаЭтапов,ТекущийРодитель) Экспорт
	НоваяСтрока = ЗакрытиеМесяцаСервер.ДобавитьЭтапВТаблицу(ТаблицаЭтапов, ТекущийРодитель,
		Перечисления.ОперацииЗакрытияМесяца.НачисленияПоКредитамДепозитамИВыданнымЗаймам);
	НоваяСтрока.ВыполняетсяВручную = Истина;
	НоваяСтрока.ТекстВыполнить = НСтр("ru='Начислить'");
	НоваяСтрока.ДействиеИспользование = ЗакрытиеМесяцаСервер.ОписаниеДействия_СервернаяПроцедура(
		"ФинансовыеИнструменты.Использование_НачисленияПоКредитамДепозитамИВыданнымЗаймам");
	НоваяСтрока.ДействиеВыполнить = ЗакрытиеМесяцаСервер.ОписаниеДействия_ОткрытьФорму(
		Метаданные.Документы.НачисленияКредитовИДепозитов.Формы.ФормаСписка.ПолноеИмя());
КонецПроцедуры

// Обработчики этапа.

Процедура Использование_НачисленияПоКредитамДепозитамИВыданнымЗаймам(ПараметрыОбработчика) Экспорт
	
	ЗакрытиеМесяцаСервер.УвеличитьКоличествоОбработанныхДанныхДляЗамера(ПараметрыОбработчика, 1);
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьДоговорыКредитовИДепозитов") Тогда
		ЗакрытиеМесяцаСервер.УстановитьСостояниеОтключено(
			ПараметрыОбработчика,
			НСтр("ru='Договоры кредитов и депозитов не используются.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ЗакрытиеМесяцаСервер.ИнициализироватьЗапрос(Запрос, ПараметрыОбработчика);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	График.ВариантГрафика КАК ВариантГрафика 
	|ПОМЕСТИТЬ Графики
	|ИЗ
	|	РегистрСведений.ГрафикНачисленийКредитовИДепозитов КАК График
	|	
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКредитовИДепозитов КАК Договор
	|	ПО График.ВариантГрафика.Владелец = Договор.Ссылка
	|		И График.ВариантГрафика.Используется
	|		И Договор.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|		И График.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|ГДЕ
	|	Договор.Организация В (&МассивОрганизаций)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	График.ВариантГрафика КАК ВариантГрафика
	|ИЗ
	|	РегистрСведений.ГрафикОплатКредитовИДепозитов КАК График
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКредитовИДепозитов КАК Договор
	|	ПО График.ВариантГрафика.Владелец = Договор.Ссылка
	|		И График.ВариантГрафика.Используется
	|		И Договор.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|		И График.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|ГДЕ
	|	Договор.Организация В (&МассивОрганизаций)
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Договор.Организация КАК Организация,
	|	Договор.Ссылка КАК Договор,
	|	График.Проценты КАК ПроцентНачисленияПлан,
	|	График.Комиссия КАК КомиссияНачисленияПлан,
	|	0 КАК ПроцентНачисленияФакт,
	|	0 КАК КомиссияНачисленияФакт
	|ПОМЕСТИТЬ втПланФактРазвернуто
	|ИЗ
	|	РегистрСведений.ГрафикНачисленийКредитовИДепозитов КАК График
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКредитовИДепозитов КАК Договор
	|	ПО График.ВариантГрафика.Владелец = Договор.Ссылка
	|		И Договор.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|		И График.ВариантГрафика.Используется
	|		И График.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|ГДЕ
	|	Договор.Организация В (&МассивОрганизаций)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Договоры.Организация,
	|	Расчеты.Договор КАК Договор,
	|	0 КАК ПроцентНачисленияПлан,
	|	0 КАК КомиссияНачисленияПлан,
	|	ВЫБОР КОГДА Расчеты.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Проценты)
	|		ТОГДА Расчеты.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПроцентНачисленияФакт,
	|	ВЫБОР КОГДА Расчеты.ТипСуммы = ЗНАЧЕНИЕ(Перечисление.ТипыСуммГрафикаКредитовИДепозитов.Комиссия)
	|		ТОГДА Расчеты.Сумма
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КомиссияНачисленияФакт
	|ИЗ
	|	РегистрНакопления.РасчетыПоФинансовымИнструментам КАК Расчеты
	|
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДоговорыКредитовИДепозитов КАК Договоры
	|	ПО Расчеты.Договор = Договоры.Ссылка
	|		И Договоры.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыДоговоровКонтрагентов.Действует)
	|		И Расчеты.ТипГрафика = ЗНАЧЕНИЕ(Перечисление.ТипыГрафиковФинансовыхИнструментов.Начисления)
	|		И Расчеты.Период МЕЖДУ &НачалоПериода И &КонецПериода
	|ГДЕ
	|	Договоры.Организация В (&МассивОрганизаций)
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втПланФакт.Организация КАК Организация,
	|	втПланФакт.Договор КАК Договор,
	|	СУММА(втПланФакт.ПроцентНачисленияПлан) КАК ПроцентНачисленияПлан,
	|	СУММА(втПланФакт.КомиссияНачисленияПлан) КАК КомиссияНачисленияПлан,
	|	СУММА(втПланФакт.ПроцентНачисленияФакт) КАК ПроцентНачисленияФакт,
	|	СУММА(втПланФакт.КомиссияНачисленияФакт) КАК КомиссияНачисленияФакт
	|ПОМЕСТИТЬ Отклонения
	|ИЗ
	|	втПланФактРазвернуто КАК втПланФакт
	|СГРУППИРОВАТЬ ПО
	|	втПланФакт.Организация,
	|	втПланФакт.Договор
	|ИМЕЮЩИЕ
	|	СУММА(втПланФакт.ПроцентНачисленияПлан) - СУММА(втПланФакт.ПроцентНачисленияФакт) > 0
	|		ИЛИ СУММА(втПланФакт.КомиссияНачисленияПлан) - СУММА(втПланФакт.КомиссияНачисленияФакт) > 0";
	
	Запрос.Выполнить();
	
	РазмерыВременныхТаблиц = ЗакрытиеМесяцаСервер.РазмерыВременныхТаблиц(Запрос, ПараметрыОбработчика);
	
	Если РазмерыВременныхТаблиц.Графики = 0 Тогда
			
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Нет графиков начислений и оплат по договорам кредитов и депозитов.'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
	Иначе
		
		ЗакрытиеМесяцаСервер.ЗафиксироватьРезультатыОбработчикаИспользованияПоОрганизациям(
			ПараметрыОбработчика,
			НСтр("ru='По организации ""%1"" за период %2 есть отклонения в плановых и фактических начислениях по договорам кредитов и депозитов.'", ОбщегоНазначения.КодОсновногоЯзыка()),
			Запрос,
			"Отклонения",
			Ложь,
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция Всего_Ф_XIRR(Платежи, Сроки, Аргумент)
	
	Рез = 0;
	
	Для Инд = 0 По Платежи.Количество() - 1 Цикл
		Рез = Рез + Ф_XIRR(Платежи[Инд], Сроки[Инд], Аргумент);
	КонецЦикла;
	
	Возврат Рез;
	
КонецФункции

Функция Всего_ДФ_XIRR(Платежи, Сроки, Аргумент)
	
	Рез = 0;
	
	Для Инд = 0 По Платежи.Количество() - 1 Цикл
		Рез = Рез + ДФ_XIRR(Платежи[Инд], Сроки[Инд], Аргумент);
	КонецЦикла;
	
	Возврат Рез;
	
КонецФункции

Функция Ф_XIRR(Платеж, Срок, Аргумент)
	
	Если Аргумент <= -1 Тогда
		Аргумент = -1 + 0.000000000001;
	КонецЕсли;
	
	Возврат Платеж * Pow((1 + Аргумент), Срок);
	
КонецФункции

Функция ДФ_XIRR(Платеж, Срок, Аргумент)
	
	Если Аргумент <= -1 Тогда
		Аргумент = -1 + 0.000000000001;
	КонецЕсли;
	
	Возврат Срок * Платеж * Pow((1 + Аргумент), (Срок - 1));
	
КонецФункции

Функция МодульЧисла(Число)
	
	Возврат Макс(Число, -Число);
	
КонецФункции

Функция ПриведенныйПлатежNPV(Ставка, Платеж, НомерПериода)
	
	Возврат Платеж / Pow((Ставка + 1), НомерПериода);
	
КонецФункции

Функция ПриведенныйПлатежXNPV(Ставка, Платеж, Срок)
	
	Возврат Платеж / Pow((Ставка + 1), Срок);
	
КонецФункции

Процедура ПреобразоватьВходящиеПараметрыЧИСТВНДОХ(Платежи, Даты)
	
	Если Платежи.Количество() <> Даты.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	ГрафикПлатежей = Новый ТаблицаЗначений; 
	ГрафикПлатежей.Колонки.Добавить("Дата", ОбщегоНазначенияУТ.ПолучитьОписаниеТиповДаты(ЧастиДаты.Дата));
	ГрафикПлатежей.Колонки.Добавить("Сумма", ОбщегоНазначенияУТ.ОписаниеТипаДенежногоПоля(ДопустимыйЗнак.Любой));
	
	Для Инд = 0 По Платежи.ВГраница() Цикл
		Если Платежи[Инд] <> 0 Тогда
			НоваяСтрока = ГрафикПлатежей.Добавить();
			НоваяСтрока.Дата = Даты[Инд];
			НоваяСтрока.Сумма = Платежи[Инд];
		КонецЕсли;
	КонецЦикла;
	
	ГрафикПлатежей.Свернуть("Дата", "Сумма");
	
	Даты = ГрафикПлатежей.ВыгрузитьКолонку("Дата");
	Платежи = ГрафикПлатежей.ВыгрузитьКолонку("Сумма");
	
КонецПроцедуры

Функция ПроверитьВходящиеПараметрыЧИСТВНДОХ(Платежи)
	
	ЕстьПоложительнаяСумма = Ложь;
	ЕстьОтрицательнаяСумма = Ложь;
	
	Для Инд = 0 По Платежи.ВГраница() Цикл
		Если Не ЕстьПоложительнаяСумма И Платежи[Инд] > 0 Тогда
			ЕстьПоложительнаяСумма = Истина;
		ИначеЕсли Не ЕстьОтрицательнаяСумма И Платежи[Инд] < 0 Тогда
			ЕстьОтрицательнаяСумма = Истина;
		КонецЕсли;
		Если ЕстьПоложительнаяСумма И ЕстьОтрицательнаяСумма Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Не (ЕстьПоложительнаяСумма И ЕстьОтрицательнаяСумма) Тогда
		ТекстСообщения = НСтр("ru='Невозможно рассчитать приблизительную годовую ставку IRR. Проверьте корректность графика платежей: по крайней мере один платеж в графике должен быть положительный и один отрицательный.'");
		ВызватьИсключение ТекстСообщения;
	КонецЕсли;
	
	Возврат ЕстьПоложительнаяСумма И ЕстьОтрицательнаяСумма;
	
КонецФункции

// Заменяет строки в подзапросах пересчета валюты
//
// Параметры:
//	ТекстЗапроса - Строка - текст запроса, в котором выполняется корректировка
//	ИмяТаблицы - Строка - имя временной таблицы
//	НесколькоОрганизаций - Булево - признак наличия списка организаций
//
Процедура КорректировкаПодзапросаПересчетаВалютПоОрганизации(ТекстЗапроса, ИмяТаблицы, НесколькоОрганизаций)
	
	Если НесколькоОрганизаций Тогда
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляОрганизаций", "
							|	ТаблицаПериодов.Организация,
							|	Организации.ВалютаРегламентированногоУчета КАК ВалютаРегл");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ТаблицаОрганизаций", "
							|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
							|		ПО ТаблицаПериодов.Организация = Организации.Ссылка");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеБазовойВалюты",
							"КурсыВалют.БазоваяВалюта = Организации.ВалютаРегламентированногоУчета");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ГруппировкаОрганизаций", "
							|	ТаблицаПериодов.Организация,
							|	Организации.ВалютаРегламентированногоУчета");
		
		Если ИмяТаблицы = "ТаблицаПериодовРегл" Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеВалюты",
							"КурсыВалют.Валюта = Организации.ВалютаРегламентированногоУчета");
		КонецЕсли;
		
	Иначе
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ПоляОрганизаций,", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, ",&ТаблицаОрганизаций", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеБазовойВалюты",
							"КурсыВалют.БазоваяВалюта = &ВалютаРегл");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ГруппировкаОрганизаций,", "");
		
		Если ИмяТаблицы = "ТаблицаПериодовРегл" Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&УсловиеВалюты",
							"КурсыВалют.Валюта = &ВалютаРегл");
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти